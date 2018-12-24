# frozen_string_literal: true

require 'terrapin'

class ImportRepos
   MAP = {
      'php_coder' => 'php-coder',
      'psolntsev' => 'p_solntsev',
      '@vim_plugins' => '@vim-plugins',
   }

   attr_reader :url, :path

   def do
      Gear.import!(repo_attrs, on_duplicate_key_ignore: true).ids
      GearMaintainer.import!(repo_maintainer_attrs, on_duplicate_key_ignore: true)
   end

   protected

   def initialize url: nil, path: nil
      @url = url
      @path = path
   end

   def maintainer_from login
      /(?<team>@)?(?<name>.*)/ =~ login
      email = name + (team && "@packages.altlinux.org" || "@altlinux.org")

      Recital::Email.find_or_create_by!(address: email) do |r_e|
         r_e.maintainer = Maintainer.find_or_initialize_by(login: login) do |m|
            m.name = name
            m.type = team && 'Maintainer::Team' || 'Maintainer::Person'
            m.email = r_e
         end
         r_e.foremost = true
      end.maintainer
   end

   def parse result
      if result !~ /\A\z/
         result.force_encoding('utf-8').split("\n").map do |line|
            /.*?(?<kind>people)\/(?<login>[^\/]+)\/packages\/(?<reponame>[^\/]+)\.git/ =~ line

            if kind
               {
                  url: File.join(url, kind, login, "packages/#{reponame}.git"),
                  reponame: reponame,
                  kind: kind.singularize,
                  login: login,
                  changed_at: Time.at(0)
               }
            else
               Rails.logger.info("IMPORT.REPO: failed to parse line #{line}")
            end
         end.compact
      end
   end

   def people_attrs
      @people_attrs ||= (
         fullpath = File.expand_path(path)
         depth = 2 + fullpath.count('/')
         args = "#{fullpath} -maxdepth #{depth} 2>/dev/null |grep packages.*\.git"

         Rails.logger.info("IMPORT.REPO: find with args #{args}")
         wrapper = Terrapin::CommandLine.new('find', args, environment: { 'LANG' => 'C', 'LC_ALL' => 'en_US.UTF-8' })
         attrs = parse(wrapper.run)

         if attrs.blank?
            Rails.logger.error('IMPORT.REPO: find exit status zero, but result is blank')
         end

         attrs)
   rescue Terrapin::CommandNotFoundError
      Rails.logger.error('IMPORT.REPO: find command not found')
   rescue Terrapin::ExitStatusError
      Rails.logger.error('IMPORT.REPO: find exit status non zero')
   end

   def repo_attrs
      people_attrs.as_json(except: :login)
   end

   def repo_maintainer_attrs
      people_attrs.map do |person|
         {
            gear_id: Gear.where(url: person[:url]).first.id,
            maintainer_id: maintainer_from(person[:login]).id
         }
      end
   end
end
