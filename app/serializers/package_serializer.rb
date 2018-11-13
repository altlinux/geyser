# frozen_string_literal: true

class PackageSerializer < RecordSerializer
   include ActionView::Helpers::NumberHelper

   attributes :name, :filename, :ftp_url, :md5, :human_size

   def human_size
      number_to_human_size(object.size)
   end

   def ftp_url
      if object.branch_paths.first
         File.join(object.branch_paths.first.ftp_url, filename)
      end
   end

   def filename
      if instance_options[:branch]
         object.rpms.by_branch_path(branch.branch_paths).first&.filename
      else
         object.rpms.first&.filename
      end
   end
end
