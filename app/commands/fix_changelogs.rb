class FixChangelogs
   def do
      Changelog.where(package_id: nil).delete_all
      Changelog.find_each do |changelog|
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
end
