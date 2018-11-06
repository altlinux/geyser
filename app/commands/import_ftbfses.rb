# frozen_string_literal: true

class ImportFtbfses
   MAP = {
      'php_coder' => 'php-coder',
      'psolntsev' => 'p_solntsev',
      '@vim_plugins' => '@vim-plugins',
   }

   ATTR_NAMES = %i(type no status severity branch_path_id repo_name evr reported_at reporter)
   LOG_ATTR_NAMES = %i(type no status severity branch_path_id repo_name evr reporter updated_at log_url)

   attr_reader :url

   def do
      Rails.logger.info("#{ Time.zone.now }: IMPORT.FTBFS")

      ApplicationRecord.transaction do
         append_stat
         remove_stat

         Issue.import!(issue_attrs, on_duplicate_key_update: {
                     conflict_target: %i(type no),
                     columns: %i(status severity branch_path_id evr repo_name reporter updated_at log_url)})
      end
   end

   protected

   def file_list_from uri
      open(URI.escape(uri)).read.split("\n")
   rescue Errno::EISDIR
      res = []

      Dir.foreach(uri) do |file|
         next if /^\.\.?$/ =~ file

         res << {
            name: file,
            time: File.mtime(File.join(uri, file))
         }
      end

      res
   rescue OpenURI::HTTPError, Errno::ENOENT
      []
   end

   def maintainer_from login
      Maintainer.find_or_create_by!(login: login) do |m|
         /(?<team>@)?(?<name>.*)/ =~ login
         m.name = name
         m.email = name + (team && "@packages.altlinux.org" || "@altlinux.org")
         m.type = team && 'Maintainer::Team' || 'Maintainer::Person'
      end
   end

   def maintainer_ids_from acls
      acls.split(',').map { |t| MAP[t] || t }.map { |l| maintainer_from(l).id }
   end

   def remove_stat
      noes = BranchPath.where.not(ftbfs_stat_uri: nil).map do |bp|
         file_list_from(bp.ftbfs_stat_uri).map do |line|
            (name, evr, weeks, acls) = line.split

            "#{bp.branch.slug}-#{bp.arch}-#{name}-#{evr}"
         end
      end.flatten

      Issue::Ftbfs.where.not(no: noes).active.update_all(resolution: "FIXED", resolved_at: Time.zone.now)
   end

   def append_stat
      now = Time.zone.now
      (attrs, assignees) = BranchPath.where.not(ftbfs_stat_uri: nil).map do |bp|
         file_list_from(bp.ftbfs_stat_uri).map do |line|
            (name, evr, weeks, acls) = line.split

            no = "#{bp.branch.slug}-#{bp.arch}-#{name}-#{evr}"
            reported_at = now - weeks.to_i.weeks

            [ [ ATTR_NAMES,
                [ 'Issue::Ftbfs',
                  no,
                  'NEW',
                  'normal',
                  bp.id,
                  name,
                  evr,
                  reported_at,
                  'hiver@altlinux.org' ]
                ].transpose.to_h,
               maintainer_ids_from(acls) ]
         end
      end.flatten(1).transpose

      result = Issue.import!(attrs, on_duplicate_key_update: {
                     conflict_target: %i(type no),
                     columns: %i(status severity branch_path_id evr repo_name reported_at reporter)})

      issue_assignee_attrs = [ assignees, result.ids ].transpose.map do |(assignee_ids, id)|
         assignee_ids.map { |assignee_id| { maintainer_id: assignee_id, issue_id: id } }
      end.flatten(1)

      IssueAssignee.import!(issue_assignee_attrs, on_duplicate_key_ignore: true)
   end

   def issue_attrs
      BranchPath.where.not(ftbfs_uri: nil).map do |bp|
         file_list_from(bp.ftbfs_uri).map do |file|
            /(?<name>.*)-(?:(?<epoch>\d+):)?(?<version>[^-]+)-(?<release>[^-]+)$/ =~ file[:name]

            evr = [ epoch, [ version, release ].join('-') ].compact.join(':')
            no = "#{bp.branch.slug}-#{bp.arch}-#{name}-#{evr}"

            [ LOG_ATTR_NAMES,
                [ 'Issue::Ftbfs',
                  no,
                  'NEW',
                  'normal',
                  bp.id,
                  name,
                  evr,
                  'hiver@altlinux.org',
                  file[:time],
                  File.join("http://git.altlinux.org", bp.ftbfs_uri, file[:name])
                ]
            ].transpose.to_h
         end
      end.flatten
   end
end
