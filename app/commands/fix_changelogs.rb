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
      id_first_cl_ids = Changelog.order(package_id: :asc, at: :desc, id: :asc).select("DISTINCT ON (package_id) id")
      Changelog.where(spkg_id: nil, id: id_first_cl_ids).update_all("spkg_id = package_id")
   end

   def stage3
      Changelog.where(maintainer_id: nil).find_each do |changelog|
         maintainer = Maintainer.import_from_changelogname(changelog.changelogname)

         changelog.update!(maintainer: maintainer)
      end
   end

   def stage4
      ActiveRecord::Base.connection.execute("UPDATE changelogs SET evr = overlay(evr placing '' from 1 for 2) WHERE evr ~ '^- '")
      #TODO update from changelogname like "- mge@arcor.de 1.3.8-26" where evr = ''
      ActiveRecord::Base.connection.execute("UPDATE changelogs SET evr = '' WHERE evr ~ ' '")

      tps_select = Arel.sql("DISTINCT ON(a.id) a.id, a.package_id")
      tps_join = Arel.sql("LEFT JOIN changelogs b ON a.id <> b.id
                                 AND a.package_id = b.package_id
                                 AND a.at = b.at")
      tps_where = Arel.sql("a.id IS NOT NULL AND b.id IS NOT NULL")
      tps = Changelog.from(Arel.sql("changelogs a"))
                     .joins(tps_join)
                     .where(tps_where)
                     .select(tps_select)

      ps_select = Arel.sql("distinct on(dup_changelogs.package_id)
                            dup_changelogs.package_id,
                            array_agg(dup_changelogs.id) AS changelog_ids,
                            specfiles.text AS spec,
                            packages.*")
      ps_join = Arel.sql("INNER JOIN (#{tps.to_sql}) AS dup_changelogs on dup_changelogs.package_id = packages.id")
      ps = Package::Src.joins(ps_join, :specfile)
                       .group("dup_changelogs.package_id, packages.name, specfiles.text, packages.id")
                       .select(ps_select)

      ps.each do |spkg|
         changelogs = Changelog.where(id: spkg.read_attribute(:changelog_ids))

         matched =
         if spec = spkg.read_attribute(:spec)
            records = spec.split("\n").map do |line|
               if /^\* (?<date>\w{3} \w{3} \d{2} \d{4}).*\s+(?<evr>\S+)$/ =~ line
                  {
                     date: Time.parse(date),
                     evr: evr
                  }
               end
            end.compact

            records.map do |r|
               i = if r[:evr].gsub(/%ubt/, '') == r[:evr]
                     changelogs.map(&:evr).index(r[:evr])
                   else
                     changelogs.map { |c| c.evr.gsub(/\.(M80C|M80P|M70C|M70T|M70P|M51|M60P|M60T|M50P|M51|M41|S)(\.?\d+)?$/, '') }.index(r[:evr].gsub(/%ubt/, ''))
                   end

               if i && changelogs[i].at.to_date == r[:date].to_date
                  r.merge(o: changelogs[i])
               end
            end.compact.reverse
         end

         if matched.present?
            matched.group_by {|r| r[:date] }.each do |_, match|
               match.each.with_index do |r, i|
                  r[:o].update!(at: r[:date] + i.hours)
               end
            end
         else
            evrs = changelogs.map do |c|
               /((?<epoch>.*):)?(?<vr>[^:]+)/ =~ c.evr

               evr = ([ epoch || "0" ] + (vr || "").split(/[^\d]+/)).map(&:to_i)

               { evr: evr, o: c }
            end

            evrs.sort_by { |evr| evr[:evr] }.each.with_index { |evr, i| evr[:o].update!(at: evr[:o].at + i.minutes) }
         end
      end
   end

   def do
      stage1
      stage2
      stage3
      stage4
   end
end
