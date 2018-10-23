# frozen_string_literal: true

require 'csv'
require 'net/http'

class ImportBugs
   attr_reader :url

   ATTR_NAMES = %i(no status resolution severity product repo_name assigned_to reporter description)

   def initialize(url)
      @url = url
   end

   def do
      Rails.logger.info("#{ Time.zone.now }: IMPORT.BUGS")

      parsed = CSV.parse(data, headers: true).to_a
      attrs = parsed[1..-1].map do |l|
         attrs = [ATTR_NAMES, l].transpose.to_h
         if branch = branch_for(attrs.delete(:product))
            attrs.merge(type: 'Issue::Bug', branch_id: branch.id)
         end
      end.compact

      Issue.import!(attrs, on_duplicate_key_update:
                    { conflict_target: %i(type no),
                      columns: %i(status resolution severity branch_id repo_name assigned_to reporter description)})
   end

   protected

   def branch_for product
      /Branch (?<branch_name>.*)|(?<sisyphus>Sisyphus)/ =~ product

      if branch_name || sisyphus
         Branch.where(name: branch_name || sisyphus).first
      end
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
