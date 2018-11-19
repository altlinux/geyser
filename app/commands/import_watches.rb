# frozen_string_literal: true

require 'nokogiri'

class ImportWatches
   MAP = {
      'php_coder' => 'php-coder',
      'psolntsev' => 'p_solntsev',
      '@vim_plugins' => '@vim-plugins',
   }

   ATTR_NAMES = %i(type no status severity branch_path_id repo_name evr reporter reported_at source_url)

   attr_reader :url, :name, :version

   def do
      Rails.logger.info("#{ Time.zone.now }: IMPORT.Watches")

      ApplicationRecord.transaction do
         append_watches
         remove_watches
      end
   end

   protected

   def data_from url
      open(URI.escape(url)).read.split("\n")
   rescue OpenURI::HTTPError, Errno::ENOENT
      []
   end

   def data
      doc = Nokogiri::HTML(open(URI.escape(url)))
      doc.css("pre a[href$=txt]")
   rescue OpenURI::HTTPError, Errno::ENOENT
      []
   end

   def maintainer_from pre_login
      login = MAP[pre_login] || pre_login
      /(?<team>@)?(?<name>.*)/ =~ login
      email = name + (team && "@packages.altlinux.org" || "@altlinux.org")

      Maintainer.where(login: login).first || Maintainer.find_or_create_by!(email: email) do |m|
         m.name = name
         m.login = login
         m.type = team && 'Maintainer::Team' || 'Maintainer::Person'
      end
   end

   def append_watches
      data.each do |a|
         /(?<login>.*)\.txt$/ =~ a.text

         maintainer = maintainer_from(login)
         attrs = issue_attrs_for(File.join(url, a.attributes["href"].text).gsub(/%40/, '@'))
         result = Issue.import!(attrs, on_duplicate_key_update: {
                       conflict_target: %i(type no),
                       columns: %i(status severity branch_path_id evr repo_name reporter reported_at source_url)})

         issue_assignee_attrs = result.ids.map { |id| { maintainer_id: maintainer.id, issue_id: id } }

         IssueAssignee.import!(issue_assignee_attrs, on_duplicate_key_ignore: true)
      end
   end

   def remove_watches
      noes = data.map do |a|
         /(?<login>.*)\.txt$/ =~ a.text

         next if !login

         url = File.join(self.url, a.attributes["href"].text.gsub(/%40/, '@'))

         self.noes(url)
      end.flatten.uniq

      Issue::Watch.where.not(no: noes).active.update_all(resolution: "FIXED", resolved_at: Time.zone.now)
   end

   def srpm
      Rpm.src
         .joins(:package, :branch)
         .where(name: name, packages: { version: version})
         .order("packages.version DESC, packages.release DESC, branches.order_id DESC")
         .first
   end

   def noes url
      data_from(url).map do |repo|
         (@name, @version, _, source_url) = repo.split

         if srpm
            "#{name}-#{srpm.evr}"
         end
      end.compact.flatten
   end

   def issue_attrs_for url
      now = Time.zone.now

      data_from(url).map do |repo|
         (@name, @version, _, source_url) = repo.split

         if srpm
            no = "#{name}-#{srpm.evr}"

            [ no,
               [ ATTR_NAMES,
                  [ 'Issue::Watch',
                     no,
                     'NEW',
                     'normal',
                     srpm.branch_path.id,
                     name,
                     srpm.evr,
                     'watch@altlinux.org',
                     now,
                     source_url
                  ]
               ].transpose.to_h
            ]
         end
      end.compact.to_h.values
   end

   def initialize url: nil
      @url = url
   end
end
