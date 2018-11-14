# frozen_string_literal: true

require 'open-uri'

class PackageSerializer < RecordSerializer
   include ActionView::Helpers::NumberHelper

   attributes :name, :filename, :ftp_url, :md5, :human_size

   def human_size
      number_to_human_size(object.size)
   end

   def ftp_url
      object.branch_paths.reduce(nil) do |res, bp|
         path = File.join(bp.ftp_url, filename)

         res || is_url_available?(path) && path || nil
      end
   end

   def filename
      if instance_options[:branch]
         object.rpms.by_branch_path(branch.branch_paths).first&.filename
      else
         object.rpms.first&.filename
      end
   end

   protected

   def is_url_available? url
      open(url)

      true
   rescue OpenURI::HTTPError
      false
   end
end
