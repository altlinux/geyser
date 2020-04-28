FactoryBot.define do
   factory :rpm do
      filename { "#{name || Faker::App.name}-#{Faker::App.semantic_version}-#{'alt' + Faker::App.semantic_version}.#{arch}.rpm" }
      package { build(:package, arch: arch.to_sym, name: filename.split('-')[0...-2].join('-'), group: group) }

      transient do
         arch { %w(i586 x86_64 noarch aarch64 mipsel armh)[rand(6)] }
         name nil
         branchname { Faker::App.name }
         branch nil
         group { build(:group) }
      end

      after(:build) do |o, e|
         if e.arch != 'src'
            o.package.src = build(:srpm).package

            if e.branch
               o.branch_path_id = e.branch.branch_paths.built.first&.id
            elsif e.branchname
               o.branch_path_id ||= Branch.where(name: e.branchname).first&.branch_paths&.built&.first&.id ||
                                 create(:branch_path, branchname: e.branchname)
            else
              o.branch_path ||= create(:branch_path).id
            end
         end
      end

      after(:create) do |o, e|
         if e.arch != 'src'
            create(:srpm, package: o.package.src)
         end
      end
   end
   
   factory :srpm, parent: :rpm do
      package { build(:spkg, name: filename.split('-')[0...-2].join('-'), group: group) }

      transient do
         arch { 'src' }
      end

      after(:build) do |o, e|
        o.branch_path_id ||= e.branch &&
          e.branch.branch_paths.src.first&.id ||
          e.branchname &&
          (Branch.where(name: e.branchname).first&.branch_paths&.src&.first&.id ||
           create(:src_branch_path, branchname: e.branchname)).id ||
          create(:src_branch_path).id
      end
   end
end
