# frozen_string_literal: true

require 'csv'
require 'net/http'

class ImportBugs
   attr_reader :url

   ATTR_NAMES = %i(no status resolution severity product repo_name assigned_to reporter description)

   DOMAINS = %w(basealt.ru altlinux.ru altlinux.org altlinux.com)

   def initialize(url)
      @url = url
   end

   def do
      Rails.logger.info("#{ Time.zone.now }: IMPORT.BUGS")

      ApplicationRecord.transaction do
         import_maintainers
         import_emails
         import_issues
      end
   end

   protected

   def absent_emails
      @absent_emails ||= parsed[1..-1].map do |l|
         [ATTR_NAMES, l].transpose.to_h[:assigned_to]
      end.compact.uniq.select do |email|
         Recital::Email.where(address: email).empty?
      end
   end

   def import_maintainers
      maintainers = absent_emails.map do |email|
         /(?<login>[^@]+)@(?<domain>.*)/ =~ email

         if DOMAINS.include?(domain)
            re_sql = ApplicationRecord.sanitize_sql_array(["address ~ ?", "#{login}@(#{DOMAINS.join('|')})"])
            Recital::Email.find_by(re_sql)&.maintainer
         end || Maintainer.new(name: email, type: 'Maintainer::Person')
      end

      res = Maintainer.import!(maintainers, on_duplicate_key_ignore: true)
      maintainers.select {|m| !m.id }.each.with_index {|m, i| m.id = res.ids[i] }
      @maintainer_ids = maintainers.map {|m| m.id }
   end

   def import_emails
      emails = absent_emails.map.with_index do |email, index|
         Recital::Email.new(address: email, maintainer_id: maintainer_ids[index])
      end

      Recital::Email.import!(emails, on_duplicate_key_ignore: true)
   end

   def import_issues
      (assigned_tos, attrs) = parsed[1..-1].map do |l|
         attrs = [ATTR_NAMES, l].transpose.to_h
         if branch_path = branch_path_for(attrs.delete(:product))
            [ attrs.delete(:assigned_to), attrs.merge(type: 'Issue::Bug', branch_path_id: branch_path.id) ]
         end
      end.compact.transpose

      result = Issue.import!(attrs,
                    on_duplicate_key_update: {
                       conflict_target: %i(type no),
                       columns: %i(status resolution severity branch_path_id repo_name reporter description)})
      issue_assignee_attrs = [ assigned_tos, result.ids ].transpose.map do |(assigned_to, id)|
         {
            maintainer_id: Recital::Email.find_by_address!(assigned_to).maintainer_id,
            issue_id: id
         }
      end

      IssueAssignee.import!(issue_assignee_attrs, on_duplicate_key_ignore: true)
   end

   def parsed
      @parsed ||= CSV.parse(data, headers: true).to_a
   end

   def branch_path_for repo_name
      /Branch (?<branch_r_name>.*)|(?<sisyphus>Sisyphus)/ =~ repo_name

      branch_name = branch_r_name || sisyphus
      BranchPath.joins(:branch).where(primary: true, branches: { name: branch_name}).first
   end

   def uri
      URI.parse(url)
   end

   def data
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      data = http.get(uri.request_uri).body
   end
end
