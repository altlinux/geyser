# frozen_string_literal: true

require 'terrapin'
require 'git'

class ImportGears
   MAP = {
      'php_coder' => 'php-coder',
      'psolntsev' => 'p_solntsev',
      '@vim_plugins' => '@vim-plugins',
   }

   attr_reader :url, :path

   def do
      Gear.import!(gear_attrs, on_duplicate_key_update: { conflict_target: %i(url),
                                                          columns: %i(changed_at updated_at) })
      GearMaintainer.import!(gear_maintainer_attrs, on_duplicate_key_update: {
                            conflict_target: %i(gear_id maintainer_id),
                            columns: %i(updated_at) })
   end

   protected

   def initialize url: nil, path: nil
      @url = url
      @path = path
   end

   def parse result
      if result !~ /\A\z/
         result.force_encoding('utf-8').split("\n").map do |line|
            /'.*?(?<kind>gear|srpm)s\/(?<first>\w)\/(?<reponame>[^\/]+)\.git'\s(?<timestamp>\d+)/ =~ line

            if kind
               {
                  url: File.join(url, kind.pluralize, reponame[0], "#{reponame}.git"),
                  reponame: reponame,
                  kind: kind,
                  updated_at: Time.at(timestamp.to_i),
                  changed_at: Time.at(timestamp.to_i)
               }
            else
               Rails.logger.info("IMPORT.GEAR: failed to parse line #{line}")
            end
         end.compact
      end
   end

   def gear_maintainer_attrs
      Gear.maintainly_unanalyzed.map do |gear|
         gear_path = gear.path_for(path)

         Rails.logger.info("IMPORT.GEAR: Maintainers for #{gear.reponame} to parse")

         begin
            g = Git::Base.bare(gear_path, log: Rails.logger)
            tags = g.tags

         rescue Git::GitExecuteError
            Rails.logger.error("IMPORT.GEAR: invalid git repo #{gear.reponame}")
            nil

         rescue ArgumentError
            Rails.logger.error("IMPORT.GEAR: invalid access to git repo #{gear.reponame}...skipped")
            nil

         else
            maintainer_times = tags.select { |t| /gb-.*-task\d+/ =~ t.name }.map do |t|
               begin
                  g.lib.commit_data(t.objectish)['author']
               rescue Git::GitExecuteError, NoMethodError
               end
            end.map do |author|
               />(?<time>.[0-9 \+]+)/ =~ author

               Rails.logger.error("IMPORT.GEAR: Invalid time in author record '#{author}' for #{gear.reponame}") if !time

               [ Maintainer.import_from_changelogname(author), Time.at(time.to_i) ]
            end.group_by { |(maintainer, time)| maintainer }

            Rails.logger.info("IMPORT.GEAR: Maintainers for #{gear.reponame} parsed")

            Rails.logger.error("IMPORT.GEAR: No tags found for #{gear.reponame}") if maintainer_times.blank?

            maintainer_times.map do |(m, times)|
               {
                  maintainer_id: m.id,
                  gear_id: gear.id,
                  updated_at: times.map { |(_, time)| time }.max,
                  created_at: times.map { |(_, time)| time }.min
               }
            end
         end
      end.compact.flatten(1)
   end

   def gear_attrs
      fullpath = File.expand_path(path)
      depth = 2 + fullpath.count('/')
      args = "#{fullpath} -maxdepth #{depth} -name *.git -type d -exec stat -c '%N %Y' {} \\;"

      Rails.logger.info("IMPORT.GEAR: find with args #{args}")
      wrapper = Terrapin::CommandLine.new('find', args, environment: { 'LANG' => 'C', 'LC_ALL' => 'en_US.UTF-8' })

      parse(wrapper.run)
   rescue Terrapin::CommandNotFoundError
      Rails.logger.error('IMPORT.GEAR: find command not found')
   rescue Terrapin::ExitStatusError
      Rails.logger.error('IMPORT.GEAR: find exit status non zero')
   end
end
