# frozen_string_literal: true

class ImportFtbfses
   MAP = {
      'php_coder' => 'php-coder',
      'psolntsev' => 'p_solntsev',
      '@vim_plugins' => '@vim-plugins',
   }

   ATTR_NAMES = %i(type no status severity branch_path_id repo_name evr reported_at touched_at reporter)
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

   def since_data
      BranchPath.where.not(ftbfs_stat_since_uri: nil).reduce({}) do |res_in, bp|
         file_list_from(bp.ftbfs_stat_since_uri).reduce(res_in) do |res, line|
            (name, at) = line.split

            res[name] ||= {}
            res[name][bp.id] = Time.at(at.to_i)
            res
         end
      end
   end

   def assignees_n_attrs
      now = Time.zone.now

      (attrs_in, assignees) = BranchPath.where.not(ftbfs_stat_uri: nil).map do |bp|
         file_list_from(bp.ftbfs_stat_uri).map do |line|
            (name, evr, weeks, acls) = line.split

            no = "#{bp.branch.slug}-#{bp.arch}-#{name}-#{evr}"
            touched_at = now - weeks.to_i.weeks

            [ { name => [ ATTR_NAMES,
                [ 'Issue::Ftbfs',
                  no,
                  'NEW',
                  'normal',
                  bp.id,
                  name,
                  evr,
                  touched_at,
                  touched_at,
                  'hiver@altlinux.org' ]
                ].transpose.to_h },
               maintainer_ids_from(acls) ]
         end
      end.flatten(1).transpose

      data = since_data
      attrs = attrs_in.map do |h|
         name = h.keys.first
         attrl = h.values.first
         attrl[:reported_at] = data[name]&.[](attrl[:branch_path_id])
         attrl
      end

      [ attrs, assignees ]
   end

   def append_stat
      (attrs, assignees) = assignees_n_attrs

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
