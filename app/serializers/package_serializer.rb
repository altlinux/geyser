# frozen_string_literal: true

class PackageSerializer < RecordSerializer
   include ActionView::Helpers::NumberHelper

   attributes :name, :filename, :ftp_url, :md5, :human_size

   def human_size
      number_to_human_size(object.size)
   end

   def ftp_url
      rpm.ftp_url
   end

   def filename
      rpm.filename
   end

   protected

   def rpm
      @rpm ||= branch_paths.reduce(nil) do |res, bp|
         res || object.rpms.by_branch_path(bp).find { |rpm| rpm.file_exists? }
      end
   end

   def branch_paths
      scope = object.branch_paths.published
      instance_options[:branch] && scope.in_branch(instance_options[:branch]) || scope
   end
end
