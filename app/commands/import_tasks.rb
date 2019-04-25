# frozen_string_literal: true

require 'terrapin'
require 'git'

class ImportTasks
   attr_reader :sources
   attr_reader :task_ids, :exercise_ids

   def do
      ApplicationRecord.transaction do
         import_tasks
         import_exercises
         import_exercise_approvers
      end
   end

   protected

   def initialize sources: raise
      @sources = sources
   end

   def parse result
      if result !~ /\A\z/
         result.force_encoding('utf-8').split("\n").map do |line|
            /'(?<path>.*)'\s(?<updated_at>\d+)/ =~ line

            begin
               file = IO.read(path)

               begin
                  task = JSON.parse(file)
                  task["uri"] = "http://git.altlinux.org#{path.gsub(/\/info.json/, '')}"
                  task["updated_at"] = Time.at(updated_at.to_i)
                  task["created_at"] = Time.at(updated_at.to_i)
                  task
               rescue JSON::ParserError
                  file = file.split("\n").map do |line|
                     line.sub(/("Elena Mishina)/, '\\\\\1\\\\')
                  end.join("\n")
                  retry
               end
            rescue Errno::ENOENT
               nil
            end
         end.compact
      else
         []
      end
   end

   def branch_path_for_repo repo_name
      branch = Branch.find_by!(slug: repo_name.gsub(/\./, '_'))
      branch.branch_paths.src.primary.first
   end

   def task_data
      @task_data ||= (
         task_data = sources.reduce([]) do |list, source|
            path = source[:path]
            depth = source[:depth]
            file = source[:file]

            parsed =
            if file && File.file?(file)
               parse(IO.read(file))
            else
               fullpath = File.expand_path(path)

               mins = (Time.zone.now - Task.changed_at.to_i + 59).to_i / 60
               args = ". -maxdepth #{depth} -mmin -#{mins} -name *.json -exec stat -c '%N %Y' $(pwd)/{} \\;"

               Rails.logger.info("Import.Tasks: find with args #{args}")
               wrapper = Terrapin::CommandLine.new('find', args, environment: { 'LANG' => 'C', 'LC_ALL' => 'en_US.UTF-8' }, expected_outcodes: [ 0, 1 ])
               Dir.chdir(fullpath) do
                  parse(wrapper.run)
               end
            end

            list + parsed
         end

         if task_data.blank?
            Rails.logger.error('Import.Repo: find exit status zero, but result is blank')
         end

         task_data || [])
   rescue Terrapin::CommandNotFoundError
      Rails.logger.error('Import.Repo: find command not found')

      []
   rescue Terrapin::ExitStatusError
      Rails.logger.error('Import.Repo: find exit status non zero')

      []
   end

   def exercise_data
      @exercise_data ||=
         [ task_data, task_ids ].transpose.map do |(task, task_id)|
            task["subtasks"]&.map do |(subtask_no, subtask)|
               if subtask["type"]
                  subtask["subtask_no"] = subtask_no
                  subtask["task_id"] = task_id
                  subtask
               end
            end&.compact
         end.compact.flatten
   end

   def exercise_approver_data
      @exercise_approver_data ||=
         [ exercise_data, exercise_ids ].transpose.map do |(exercise, exercise_id)|
            exercise["approvers"]&.map do |approver|
               {
                  "login" => approver,
                  "exercise_id" => exercise_id,
               }
            end
         end.compact
   end

   def tasks
      @tasks ||=
         task_data.map do |task|
            branch_path_id = branch_path_for_repo(task["repo"]).id

            Task.new(no: task["taskid"],
                     state: task["state"],
                     shared: task["shared"],
                     test: task["test_only"],
                     try: task["try"],
                     iteration: task["iter"],
                     owner_slug: task["owner"],
                     branch_path_id: branch_path_id,
                     uri: task["uri"],
                     created_at: task["created_at"],
                     changed_at: task["updated_at"],
                     updated_at: task["updated_at"])
         end
   end

   def exercises
      @exercises ||=
         exercise_data.map do |exercise|
            pkgname = exercise["pkgname"] || exercise["package"] || (
               if exercise["dir"]
                  /([^\/]+?)(.inv)?(.git)?$/.match(exercise["dir"])[1]
               elsif exercise["srpm"]
                  exercise["srpm"].split("-")[0..-3].join("-")
               end)

            resource = exercise["dir"] && File.join("http://git.altlinux.org/", exercise["dir"]) ||
                       exercise["copy_repo"] && [ exercise["copy_repo"], exercise["package"] ].join(":") ||
                       exercise["srpm"]
            Exercise.new(no: exercise["subtask_no"],
                         kind: exercise["type"],
                         pkgname: pkgname,
                         resource: resource,
                         sha: exercise["tag_id"],
                         task_id: exercise["task_id"],
                         committer_slug: exercise["userid"])
         end
   end

   def exercise_approvers
      exercise_approver_data.map do |exercise_approver|
         ExerciseApprover.new(exercise_id: exercise_approver["exercise_id"],
                              approver_slug: exercise_approver["login"])
      end
   end

   def import_exercise_approvers
      ExerciseApprover.import!(exercise_approvers, on_duplicate_key_ignore: true)
   end

   def import_exercises
      @exercise_ids = Exercise.import!(exercises, on_duplicate_key_update: { conflict_target: %i(task_id no),
                                                                             columns: %i(kind pkgname resource sha committer_slug) }).ids
   end

   def import_tasks
      @task_ids = Task.import!(tasks, on_duplicate_key_update: { conflict_target: %i(no),
                                                                 columns: %i(state uri shared test try iteration changed_at owner_slug branch_path_id) }).ids
   end
end
