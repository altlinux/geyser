# frozen_string_literal: true

class Changelog < ApplicationRecord
   belongs_to :package, class_name: 'Package::Src', optional: true
   belongs_to :maintainer, optional: true
   belongs_to :spkg, class_name: 'Package::Src', optional: true

   validates_presence_of :at, :text

   delegate :shown_name, :locked_email, to: :maintainer, allow_nil: true, prefix: true

   def date
      at.to_date
   end

   class << self
      def import_from rpm, package
         attrs =
            rpm.change_log.map.with_index do |changelog, index|
               /(?<name>.*?)[ <>]*(?<pre_email>[^<>@ ]+(?:@| at )[^<>@ ]+)[ <>]*(?<evr>.*)/ =~ changelog[1]

               if pre_email
                  maintainer = Maintainer.find_or_create_by!(email: FixMaintainerEmail.new(pre_email).execute) do |m|
                     m.name = name
                  end
               end

               text = if changelog[2].encoding == "UTF-8"
                     changelog[2]
                  elsif changelog[2].ascii_only?
                     changelog[2].encode("UTF-8")
                  else
                     changelog[2].dup.force_encoding("ISO-8859-1").encode("UTF-8", replace: nil)
                  end

               attrs = {
                  at: Time.at(changelog[0].to_i),
                  text: text,
                  evr: evr.to_s,
                  maintainer_id: maintainer&.id,
                  package_id: package.id,
                  spkg_id: index == 0 && package.id || nil
               }
            end.compact

         Changelog.import!(attrs)
      end
   end
end
