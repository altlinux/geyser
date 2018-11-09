# frozen_string_literal: true

require 'open-uri'

class ImportRepocopPatches
   attr_reader :url

   def do
      log :info

      attrs = repocop_patch_attrs
      RepocopPatch.import!(attrs, on_duplicate_key_update: {
             conflict_target: %i(package_id),
             columns: %i(text updated_at)})
   end

   protected

   def list
      doc = Nokogiri::HTML(open(URI.escape(url)))
      doc.css("pre a[href$='digest.diff']")
   rescue OpenURI::HTTPError, Errno::ENOENT
      []
   end

   def patch_from uri
      open(URI.escape(uri)).read
   rescue OpenURI::HTTPError, Errno::ENOENT
      nil
   end

   def repocop_patch_attrs
      now = Time.zone.now

      list.map do |a|
         file_url = File.join(url, a.attributes["href"].text)

         /^(?<name>\S+)-(?<version>[^-\s]+)-(?<release>[^-\s]+)-digest/ =~ file_url.split('/').last

         if pkg = Package::Src.where(name: name, version: version, release: release).first
            {
               package_id: pkg.id,
               text: patch_from(file_url),
               updated_at: now
            }
         else
            log :error, "source package #{name}-#{version}-#{release} isn't found"
         end
      end.compact.flatten
   end

   def log kind, text = nil
      msg = [ "#{ Time.zone.now } [#{kind.to_s.upcase}]: IMPORT.REPOCOP_REPORTS", text ].compact.join(": ")

      Rails.logger.send(kind, msg)

      nil
   end

   def initialize url: nil
      @url = url
   end
end
