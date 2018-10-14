class FixLostRpms
   def do
      count = Package::Built.where("src_id = id").count
      Rails.logger.info "FIX: #{count} pkg records to fix"

      attrses = []
      begin
      rules = [
         [  ->(pkg) do
               Package::Src.where("packages.buildtime = ? AND packages.buildtime > '2018-08-10'", pkg.buildtime)
            end,
            ->(pkg) do
               spkgs = Package::Src.joins(:branches).where("packages.buildtime = ? AND packages.buildtime > '2018-08-10'", pkg.buildtime).distinct
               spkgs.size == 1 && spkgs.first || nil
            end ],
         [  ->(pkg) do
               if filepath = pkg.first_presented_filepath
                  rpm = Rpm::Base.new(filepath)
                  Package::Src.joins(:rpms).where(rpms: { filename: rpm.sourcerpm })
               else
                  Package::Src.none
               end
            end,
            ->(pkg) do
               if filepath = pkg.first_presented_filepath
                  rpm = Rpm::Base.new(filepath)
                  spkgs = Package::Src.joins(:branches, :rpms).where(rpms: { filename: rpm.sourcerpm })
                  spkgs.size == 1 && spkgs.first || nil
               end
            end ],
         [ ->(pkg) do
                  /^(lib)?(?<name>.*?)(-devel|-debuginfo)?$/ =~ pkg.name
                  Package::Src.where("packages.name = ? AND packages.buildtime < ? AND packages.buildtime > '2018-08-10'", name, pkg.buildtime).distinct
            end,
            ->(pkg) do
               /^(lib)?(?<name>.*?)(-devel|-debuginfo)?$/ =~ pkg.name
               spkgs = Package::Src.joins(:branches).where("packages.name = ? AND packages.buildtime < ? AND packages.buildtime > '2018-08-10'", name, pkg.buildtime).distinct
               if spkgs.size > 1
                  sspkgs = spkgs.where(version: pkg.version)
                  sspkgs.size == 1 && sspkgs.first || nil
               elsif spkgs.size == 1
                  spkgs.first
               end
            end ],
         [  ->(pkg) do
               /^(?<pre>lib)?(?<name>.*?)(?<post>-devel|-debuginfo|-server)?$/ =~ pkg.name
               re = "%package -n #{Regexp.escape(pkg.name)}"
               scope = Package::Src.joins(:specfile).where("specfiles.text ~ ?", re)
               scope_n = if pre || post
                  re = "%package -n #{Regexp.escape("#{pre}%name#{post}")}"
                  scope.or(Package::Src.joins(:specfile).where("specfiles.text ~ ? AND packages.name = ?", re, name))
               else
                  scope
               end
               scope_n.where("packages.buildtime < ? AND packages.buildtime > '2018-08-10'", pkg.buildtime).distinct
            end,
            ->(pkg) do
               /^(?<pre>lib)?(?<name>.*?)(?<post>-devel|-debuginfo|-server)?$/ =~ pkg.name
               re = "%package -n #{Regexp.escape(pkg.name)}"
               scope = Package::Src.joins(:branches, :specfile).where("specfiles.text ~ ?", re)
               scope_n = if pre || post
                  re = "%package -n #{Regexp.escape("#{pre}%name#{post}")}"
                  scope.or(Package::Src.joins(:branches, :specfile).where("specfiles.text ~ ? AND packages.name = ?", re, name))
               else
                  scope
               end
               spkgs = scope_n.where("packages.buildtime < ? AND packages.buildtime > '2018-08-10'", pkg.buildtime).distinct
               spkgs.size == 1 && spkgs.first || nil
            end ],
      ]

      Package::Built.where("src_id = id").find_each.with_index do |pkg, index|
         attrs = rules.reduce(nil) do |attrs, (rule, post)|
            next attrs if attrs

            spkgs = rule[pkg]
            spkg = spkgs.first
            if spkgs.size > 1
               spkg = post[pkg]
               spkg && pkg.attributes.symbolize_keys.merge(src_id: spkg.id) || nil
            elsif spkgs.size > 0
               pkg.attributes.symbolize_keys.merge(src_id: spkg.id)
            end
         end

         if attrs
            attrses << attrs
            Rails.logger.info "FIX.#{index}: fix for #{pkg.name} package with spkg id: #{attrs[:src_id]}"
         else
            Rails.logger.info "FIX.#{index}: nofix for #{pkg.name} package"
         end
      end
      rescue Exception
         puts "#{$!.class}: #{$!.message} -> \n#{$!.backtrace.join("\n")}"
      end

      Package.import!(attrses,
                      on_duplicate_key_update: {
                         conflict_target: [:md5],
                         columns: [:src_id]
                     })
   end
end
