# frozen_string_literal: true

class ImportRepocopReports
   ATTR_NAMES = %i(package_id kind status description updated_at)
   STATUSES = %w(skip ok experimental info warn fail)

   attr_reader :url

   def do
      log :info

      package_ids = nil
      ApplicationRecord.transaction do
         attrs = repocop_note_attrs
         RepocopNote.import!(attrs, on_duplicate_key_update: {
             conflict_target: %i(package_id kind),
             columns: %i(status description updated_at)})

         update_package_status
         update_source_package_status
      end
   end

   protected

   def list
      doc = Nokogiri::HTML(open(URI.escape(url)))
      doc.css("pre a[href$=txt]")
   rescue OpenURI::HTTPError, Errno::ENOENT
      []
   end

   def list_from uri
      open(URI.escape(uri)).read.split("\n")
   rescue OpenURI::HTTPError, Errno::ENOENT
      []
   end

   def repocop_note_attrs
      list.map do |a|
         file_url = File.join(url, a.attributes["href"].text)

         repocop_note_attrs_for(file_url)
      end.flatten
   end

   def repocop_note_attrs_for url
      now = Time.zone.now

      list_from(url).map do |repocop_note_line|
         /^(?<name>\S+)-(?<version>[^-\s]+)-(?<release>[^-\s]+)\.(?<arch>[^\.\s]+)\s+(?<kind>\S+)\s(?<status>\S+)\s+(?<desc>\S.*)/ =~ repocop_note_line

         pkg = Package.where(name: name, version: version, release: release, arch: arch).first

         if pkg
            [
               ATTR_NAMES,
               [ 
                  pkg.id,
                  kind,
                  STATUSES.index(status),
                  desc,
                  now
               ]
            ].transpose.to_h
         else
            log :error, "package #{name}-#{version}-#{release} for arch #{arch} isn't found"
         end
      end.compact
   end

   def update_package_status
      q = "    WITH t_packages AS (
             SELECT packages.id,
                    MAX(repocop_notes.status) as repocop_status
               FROM packages
         INNER JOIN repocop_notes
                 ON repocop_notes.package_id = packages.id
           GROUP BY packages.id)
             UPDATE packages
                SET repocop_status = t_packages.repocop_status
               FROM t_packages
              WHERE packages.id = t_packages.id
                AND packages.repocop_status = 0"

         Package.connection.execute(q)
   end

   def update_source_package_status
      q = "    WITH t_packages AS (
             SELECT packages.src_id,
                    MAX(packages.repocop_status) as repocop_status
               FROM packages
           GROUP BY packages.src_id)
             UPDATE packages
                SET repocop_status = t_packages.repocop_status
               FROM t_packages
              WHERE packages.id = t_packages.src_id"

         Package.connection.execute(q)
   end

   def log kind, text = nil
      msg = [ "#{ Time.zone.now }: IMPORT.REPOCOP_REPORTS", text ].compact.join(": ")

      Rails.logger.send(kind, msg)

      nil
   end

   def initialize url: nil
      @url = url
   end
end
