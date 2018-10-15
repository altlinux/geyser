class FixChangelogs
   def stage1
      Changelog.where(package_id: nil).delete_all
      Changelog.where(at: nil).find_each do |changelog|
         evr = changelog.changelogname.split(/>/, -1).last.strip
         maintainer = Maintainer.import_from_changelogname(changelog.changelogname)
         text = if changelog.changelogtext.encoding == "UTF-8"
               changelog.changelogtext
            elsif changelog.changelogtext.ascii_only?
               changelog.changelogtext.encode("UTF-8")
            else
               changelog.changelogtext.dup.force_encoding("ISO-8859-1").encode("UTF-8", replace: nil)
            end

         changelog.update!(maintainer: maintainer,
                           at: Time.at(changelog.changelogtime.to_i),
                           text: text,
                           evr: evr)
      end
   end

   def stage2
      # selects the only first changelog record for each package src
      id_first_cl_ids = Changelog.where(spkg_id: nil).order(package_id: :asc, at: :desc, id: :asc).select("DISTINCT ON (package_id) id")
      Changelog.where(id: id_first_cl_ids).update_all("spkg_id = package_id")
   end

   def do
      stage1
      stage2
   end
end
