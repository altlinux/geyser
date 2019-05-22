# frozen_string_literal: true

require 'terrapin'

class ImportTaskRpms
   attr_reader :range

   def do
      ApplicationRecord.transaction do
         import_task_rpms
      end
   end

   protected

   def initialize range
      @range = range || (0..-1)
   end

   def parse result, options = {}
      if result !~ /\A\z/
         result.force_encoding('utf-8').split("\n").map do |line|
            /(?<md5>[a-f0-9]+)\s(?<file_name>.*)/ =~ line

            { md5: md5, task_id: options[:task].id }
         end
      else
         []
      end
   end

   def task_rpm_data
      @task_rpm_data ||= (
         task_rpm_data = Task.all.slice(range).reduce([]) do |list, task|
            path = task.uri.gsub("http://git.altlinux.org", '')

            args = "#{path}/ -name *.rpm -exec md5sum {} \\;"

            Rails.logger.info("Import.TaskRpms: find with args #{args}")
            wrapper = Terrapin::CommandLine.new('find', args, environment: { 'LANG' => 'C', 'LC_ALL' => 'en_US.UTF-8' }, expected_outcodes: [ 0, 1 ])

            parsed = parse(wrapper.run, task: task)

#      binding.pry  if wrapper.exit_status == 0

            list + parsed
         end

         if task_rpm_data.blank?
            Rails.logger.error('Import.TaskRpms: find exit status zero, but result is blank')
         end

         task_rpm_data || [])
   rescue Terrapin::CommandNotFoundError
      Rails.logger.error('Import.TaskRpms: find command not found')

      []
   rescue Terrapin::ExitStatusError
      Rails.logger.error('Import.TaskRpms: find exit status non zero')

      []
   end

   def import_task_rpms
      TaskRpm.import!(task_rpm_data, on_duplicate_key_ignore: true)
   end
end
