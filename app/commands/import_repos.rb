# frozen_string_literal: true

require 'terrapin'
require 'git'

class ImportRepos
   DOMAINS = %w(basealt.ru altlinux.ru altlinux.org altlinux.com)

   attr_reader :url, :path, :scope, :depth
   attr_reader :maintainer_ids, :tag_ids

   def do
      ApplicationRecord.transaction do
         import_repos
         import_maintainers
         import_emails
         import_tags
         import_repo_tags
      end
   end

   protected

   def initialize url: nil, path: nil, scope: raise, depth: raise
      @url = url
      @path = path
      @scope = scope
      @depth = depth
   end

   def parse result
      if result !~ /\A\z/
         result.force_encoding('utf-8').strip.split("\n").map do |line|
            /'(?<path>.*?(?<kind>gears|srpms|people)\/(?<holder_slug>[^\/]+)?.*\/(?<name>[^\/]+?)(\.old)?\.git)'\s(?<timestamp>\d+)/ =~ line

            if kind
               Repo.new(path: path,
                        uri: File.join(url, path),
                        name: name,
                        holder_slug: kind == 'people' && holder_slug || nil,
                        kind: kind.singularize,
                        changed_at: Time.at(timestamp.to_i))
            else
               Rails.logger.info("Import.Repo: failed to parse line #{line}")

               nil
            end
         end.compact
      else
         []
      end
   end

   def tag_data
      @tag_data ||=
      Repo.send(scope).where(uri: repo_uris).map do |repo|
         repo_path = repo.path_for(path)

         Rails.logger.info("Import.Repo: Maintainers for #{repo.name} to parse")

         begin
            g = Git::Base.bare(repo_path, log: Rails.logger)
            tags = g.tags

         rescue Git::GitExecuteError
            Rails.logger.error("Import.Repo: invalid git repo #{repo.name}")
            nil

         rescue ArgumentError
            Rails.logger.error("Import.Repo: invalid access to git repo #{repo.name}...skipped")
            nil

         else
            tags.map do |t|
               begin
                  g.lib.commit_data(t.objectish).merge(repo_id: repo.id,
                                                       name: t.name).symbolize_keys
               rescue Git::GitExecuteError, NoMethodError => e
                  Rails.logger.info("Import.Repo [#{e.class}]: #{e.message} for tag #{t.inspect}")
                  nil
               rescue Exception => e
                  $stderr.puts("Import.Repo [#{e.class}]: #{e.message} for tag #{t.inspect}:\n\t#{e.backtrace.join("\n\t")}")
                  Rails.logger.info("Import.Repo [#{e.class}]: #{e.message} for tag #{t.inspect}:\n\t#{e.backtrace.join("\n\t")}")

                  nil
               end
            end
         end
      end.flatten(1).compact.uniq { |t| t[:sha] }
   end

   def absent_emails
      @absent_emails ||= tag_data.map do |tag|
         %i(author committer).map do |t|
            Maintainer.parse_changelogname(tag[t])[:email]
         end.compact
      end.flatten.uniq.select do |email|
         Recital::Email.where(address: email).empty?
      end
   end

   def emails
      @emails ||= absent_emails.map.with_index do |email, index|
         Recital::Email.new(address: email, maintainer_id: maintainer_ids[index])
      end
   end

   def maintainers
      @maintainers ||= absent_emails.map do |email|
         /(?<login>[^@]+)@(?<domain>.*)/ =~ email

         if DOMAINS.include?(domain)
            re_sql = ApplicationRecord.sanitize_sql_array(["address ~ ?", "#{login}@(#{DOMAINS.join('|')})"])
            Recital::Email.find_by(re_sql)&.maintainer
         end || Maintainer.new(name: email, type: 'Maintainer::Person')
      end
   end

   def tags
      @tags ||= tag_data.map do |tag|
         tagger = Maintainer.parse_changelogname(tag[:author])
         committer = Maintainer.parse_changelogname(tag[:committer])
         not_alt = tag[:name] !~ /-alt/
         not_signed = tag[:message] !~ /-----BEGIN PGP SIGNATURE-----/

         Tag.new(name: tag[:name],
                 sha: tag[:sha],
                 alt: !not_alt,
                 signed: !not_signed,
                 authored_at: tagger[:at],
                 tagged_at: committer[:at],
                 author_id: Recital::Email.find_by!(address: tagger[:email]).maintainer_id,
                 tagger_id: Recital::Email.find_by!(address: committer[:email]).maintainer_id,
                 message: tag[:message])
      end
   end

   def repos
      @repos ||= (
         fullpath = File.expand_path(path)

         mins = (Time.zone.now - Repo.changed_at(scope).to_i + 59).to_i / 60
         args = "#{fullpath} -maxdepth #{depth} -mmin -#{mins} -name *.git -type d -exec stat -c '%N %Y' {} \\;"

         Rails.logger.info("Import.Repo: find with args #{args}")
         wrapper = Terrapin::CommandLine.new('find', args, environment: { 'LANG' => 'C', 'LC_ALL' => 'en_US.UTF-8' }, expected_outcodes: [ 0, 1 ])
         repos = parse(wrapper.run)

         if repos.blank?
            Rails.logger.error('Import.Repo: find exit status zero, but result is blank')
         end

         repos)
   rescue Terrapin::CommandNotFoundError
      Rails.logger.error('Import.Repo: find command not found')

      []
   rescue Terrapin::ExitStatusError
      Rails.logger.error('Import.Repo: find exit status non zero')

      []
   end

   def repo_tags
      [ tag_data.map {|t| t[:repo_id] }, tag_ids ].transpose.map { |(repo_id, tag_id)| RepoTag.new(repo_id: repo_id, tag_id: tag_id) }
   end

   def import_emails
      Recital::Email.import(emails, on_duplicate_key_ignore: true, validate: false, raise_error: true)
   end

   def import_maintainers
      res = Maintainer.import(maintainers, on_duplicate_key_ignore: true, validate: false, raise_error: true)
      maintainers.select {|m| !m.id }.each.with_index {|m, i| m.id = res.ids[i] }
      @maintainer_ids = maintainers.map {|m| m.id }
   end

   def import_repo_tags
      RepoTag.import!(repo_tags, on_duplicate_key_ignore: true)
   end

   def import_tags
      @tag_ids = Tag.import!(tags, on_duplicate_key_update: { conflict_target: %i(sha), columns: %i(name) }).ids
   end

   def repo_uris
      repos.map {|repo| repo.uri }
   end

   def import_repos
      Repo.import!(repos, on_duplicate_key_update: { conflict_target: %i(uri),
                                                     columns: %i(changed_at) })
   end
end
