# frozen_string_literal: true

class PackageSerializer < RecordSerializer
   include ActionView::Helpers::NumberHelper

   attributes :name, :filename, :ftp_url, :md5, :human_size, :valid_url

   def human_size
      number_to_human_size(object.size)
   end

   def ftp_url
      rpm&.ftp_url
   end

   def valid_url
      ftp_url && Excon.head(ftp_url).status == 200
   end

   def filename
      rpm&.filename
   end

   protected

   def rpm
      @rpm ||= object.rpms.first
   end

   def branch_paths
      scope = object.branch_paths.published
      branch && scope.for_branch(branch) || scope
   end

   def branch
      instance_options[:branch]
   end
end
