# frozen_string_literal: true

require 'open-uri'

class PackageDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper

  delegate_all

  def as_json(*)
    {
      id: id,
      name: name,
      version: version,
      release: release,
      epoch: epoch,
      arch: arch,
      summary: summary,
      license: license,
      url: url,
      description: description,
      buildtime: buildtime.iso8601,
      group_id: group_id,
      group: group.name,
      md5: md5,
      groupname: groupname,
      size: size,
      vendor: vendor,
      distribution: distribution,
      repocop: repocop,
      builder_id: builder.id,
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601
    }
  end

   def short_url
      if url
         create_link
      else
         '&ndash;'.html_safe
      end
   end

   def evr
      if epoch
         "#{ epoch }:#{ version }-#{ release }"
      else
         "#{ version }-#{ release }"
      end
   end

   def human_size
      number_to_human_size(size)
   end

   def ftp_url
      branch_paths.published.reduce(nil) do |res, bp|
         path = File.join(bp.ftp_url, filename)

         res || is_url_available?(path) && path || nil
      end
   end

   def is_url_available? url
      open(url)

      true
   rescue OpenURI::HTTPError
      false
   end

   def filename
      rpms.first&.filename
   end

   def filename_in branch
      rpms.by_branch_path(branch.branch_paths).first&.filename
   end

   private

   def create_link
      if url.length > 27
         local_link_to("#{ url[0..26] }...")
      else
         local_link_to(url)
      end
  end

   def local_link_to(text)
      h.link_to(text, url, class: 'news', rel: 'nofollow')
   end
end
