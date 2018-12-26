# frozen_string_literal: true

require 'rails_helper'

describe Package::Src do
   it { is_expected.to be_a(Package) }

   let(:srpm) { create(:srpm, name: 'openbox') }
   let(:package) { srpm.package }
   let(:branch) { create(:branch, :with_paths, name: 'Sisyphus', vendor: 'ALT Linux') }
   let(:branch_path) { create(:src_branch_path, path: Rails.root.join("spec/data"), branch: branch) }

   context 'Associations' do
      it { is_expected.to have_one(:specfile).with_foreign_key(:package_id).inverse_of(:package).dependent(:destroy) }
      it { is_expected.to have_one(:changelog).with_foreign_key(:spkg_id).inverse_of(:spkg).dependent(:destroy) }
      it { is_expected.to have_one(:repocop_patch).with_foreign_key('package_id') }
      it do
         is_expected.to have_one(:gear)
            .order(changed_at: :desc)
            .with_primary_key('name')
            .with_foreign_key('reponame')
      end
      it do
         is_expected.to have_one(:srpm_git)
            .order(changed_at: :desc)
            .with_foreign_key('reponame')
            .with_primary_key(:name)
            .class_name('Gear')
      end

      it { is_expected.to have_many(:packages).with_foreign_key('src_id').class_name('Package::Built').dependent(:destroy) }
      it { is_expected.to have_many(:all_packages).with_foreign_key('src_id').class_name('Package') }
      it { is_expected.to have_many(:built_rpms).through(:packages).source(:rpms).class_name('Rpm') }
      it { is_expected.to have_many(:changelogs).with_foreign_key(:package_id).inverse_of(:package).dependent(:destroy) }
      it { is_expected.to have_many(:patches).with_foreign_key(:package_id).inverse_of(:package).dependent(:destroy) }
      it { is_expected.to have_many(:sources).with_foreign_key(:package_id).inverse_of(:package).dependent(:destroy) }
      it { is_expected.to have_many(:gears).with_foreign_key('reponame').with_primary_key(:name).order(changed_at: :desc) }
      it { is_expected.to have_many(:acls).with_foreign_key('package_name').with_primary_key(:name) }
      it { is_expected.to have_many(:contributors).through(:changelogs).source(:maintainer).class_name('Maintainer').order(:name) }
   end

   context '#to_param' do
      subject { package }

      its(:to_param) { is_expected.to eq('openbox') }
   end

   context 'Behaviour' do
      before do
         # NOTE this fixes "uninitialized constant RSpec::Support::Differ"
         allow(File).to receive(:exist?).and_call_original
      end

      it 'is expected import srpm file' do
         file = Rails.root.join('spec/data/catpkt-1.0-alt5.src.rpm')
         rpm = Rpm::Base.new(file)

         expect(rpm.name).to eq('catpkt')
         expect(rpm.arch).to eq('src')
         expect(rpm.version).to eq('1.0')
         expect(rpm.release).to eq('alt5')
         expect(rpm.epoch).to eq(nil)
         expect(rpm.summary).to eq('FTS Packet Viewer')
         expect(rpm.group).to eq('Text tools')
         expect(rpm.license).to eq('BSD-like')
         expect(rpm.packager).to eq('Igor Zubkov <icesik@altlinux.org>')
         expect(rpm.vendor).to eq('ALT Linux Team')
         expect(rpm.distribution).to eq('ALT Linux')
         expect(rpm.description).to eq("Viewer for out/in-bound ftn-packets. Execution catpkt with no parameters\nwill give you help. There is no point address support, maybe, because, I'm\na bit lazy for all this stuff. You can use and modify it for free, the one\nthing I ask you for, is to e-mail me your diffs. Recoding from cp866 charset\nto koi8-r included by default (you can change this).")
         # TODO: add buildhost
         expect(rpm.buildtime).to eq(Time.at(1_349_449_185))
         expect(rpm.md5).to eq(`md5sum #{ file }`.split.first)
         expect(rpm.size).to eq(14_216)
         expect(rpm.filename).to eq("catpkt-1.0-alt5.src.rpm")
         expect(rpm.file).to eq(file)
         expect(rpm.change_log.last).to match_array(["1118145600",
                                                     "Igor Zubkov <icesik@altlinux.ru> 1.0-alt1",
                                                     "- Initial build for Sisyphus."])

         expect { described_class.import(branch_path, rpm) }.to change(Package, :count).by(1)

         srpm = Package.first

         expect(srpm.name).to eq('catpkt')
         expect(srpm.version).to eq('1.0')
         expect(srpm.release).to eq('alt5')
         expect(srpm.epoch).to be_nil
         expect(srpm.summary).to eq('FTS Packet Viewer')
         expect(srpm.group.full_name).to eq('Text tools')
         expect(srpm.groupname).to eq('Text tools')
         expect(srpm.license).to eq('BSD-like')
         expect(srpm.description).to eq("Viewer for out/in-bound ftn-packets. Execution catpkt with no parameters\nwill give you help. There is no point address support, maybe, because, I'm\na bit lazy for all this stuff. You can use and modify it for free, the one\nthing I ask you for, is to e-mail me your diffs. Recoding from cp866 charset\nto koi8-r included by default (you can change this).")
         expect(srpm.vendor).to eq('ALT Linux Team')
         expect(srpm.distribution).to eq('ALT Linux')
         expect(srpm.buildtime).to eq(Time.at(1_349_449_185))
         expect(srpm.changelogs.last.at).to eq(Time.at(1_118_145_600))
         expect(srpm.changelogs.last.maintainer.name).to eq('Igor Zubkov')
         expect(srpm.changelogs.last.text).to eq('- Initial build for Sisyphus.')
         expect(srpm.size).to eq(14_216)
         expect(srpm.md5).to eq("35f0f45bfbcdaf8754713fc1c97f8068")
         expect(srpm.rpms.first.filename).to eq('catpkt-1.0-alt5.src.rpm')
         expect(srpm.rpms.first.name).to eq('catpkt')

         expect(srpm.patches.first.filename).to eq("catpkt-1.0-alt-dont-strip.patch")
         expect(srpm.sources.first.filename).to eq("catpkt-1.0.tar.gz")

         expect(srpm.descriptions.first).to be_nil
         expect(srpm.summaries.first).to be_nil
      end

      it 'is expected import srpm file containing ru codepage' do
         file = Rails.root.join('spec/data/fonts-ttf-vera-1.10-alt3.src.rpm')
         rpm = Rpm::Base.new(file)

         expect { described_class.import(branch_path, rpm) }.to change(Package, :count).by(1)

         srpm = Package.first

         expect(srpm.descriptions.first.text).to eq("Этот пакет содержит свободно распространяемые шрифты Bitstream Vera.")
         expect(srpm.summaries.first.text).to eq("Шрифты Bitstream Vera")
      end

      it 'should import all srpms from path' do
         expect { described_class.import_all(branch_path.branch) }.to change(Package, :count).by(3)
      end

      context '#by_branch' do
         before do
            create_list(:srpm, 10, branch: branch)
            create(:branch)
            create_list(:srpm, 5)
         end

         it { expect(described_class.by_branch_slug(branch.slug).count).to eq(10) }
      end
   end
end
