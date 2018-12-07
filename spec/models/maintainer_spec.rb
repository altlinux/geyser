# frozen_string_literal: true

require 'rails_helper'

describe Maintainer do
   let(:person) { create(:person, login: 'person') }

   it { is_expected.to be_a(ApplicationRecord) }

   context 'Associations' do
      it { is_expected.to have_many(:rpms).through(:packages) }
      it { is_expected.to have_many(:branch_paths).through(:rpms) }
      it { is_expected.to have_many(:branches).through(:branch_paths) }
      it { is_expected.to have_many(:branching_maintainers).dependent(:delete_all) }
      it { is_expected.to have_many(:gear_maintainers) }
      it { is_expected.to have_many(:gears).through(:gear_maintainers) }
      it { is_expected.to have_many(:changelogs) }
      it { is_expected.to have_many(:issue_assignees) }
      it { is_expected.to have_many(:ftbfs).class_name('Issue::Ftbfs').through(:issue_assignees).source(:issue) }
      it { is_expected.to have_many(:bugs).class_name('Issue::Bug').through(:issue_assignees).source(:issue) }
      it { is_expected.to have_many(:built_names).through(:packages).source(:rpms) }
      it { is_expected.to have_many(:acls).with_primary_key('login').with_foreign_key('maintainer_slug') }
      it { is_expected.to have_many(:acl_names).with_primary_key('login').with_foreign_key('maintainer_slug').class_name(:Acl) }
      it { is_expected.to have_many(:gear_names).through(:gear_maintainers).source(:gear).class_name(:Gear) }
      it { is_expected.to have_many(:emails).class_name('Recital::Email') }
   end

   context 'Validation' do
      it { is_expected.to validate_presence_of(:name) }
   end

   context 'common' do
      subject { person }

      it 'is_expected.to return Maintainer.login on .to_param' do
         expect(subject.to_param).to eq('person')
         expect(subject.slug).to eq('person')
      end
   end

   context 'import' do
      it 'is_expected.to create one Maintainer' do
         expect {
            Maintainer.import_from_changelogname('Igor Zubkov <icesik@altlinux.org>')
         }.to change(Maintainer, :count).by(1)
      end

      it 'is_expected.to not create Maintainer if Maintainer already exists' do
         Maintainer.import_from_changelogname('Igor Zubkov <icesik@altlinux.org>')
         expect {
            Maintainer.import_from_changelogname('Igor Zubkov <icesik@altlinux.org>')
         }.not_to change(Maintainer, :count)
      end

      it 'is_expected.to create new Maintainer team' do
         expect {
            Maintainer.import_from_changelogname('Ruby Maintainers Team <ruby@packages.altlinux.org>')
         }.to change(Maintainer::Team, :count).by(1)
      end

      it 'is_expected.to not create new Maintainer team' do
         Maintainer.import_from_changelogname('Ruby Maintainers Team <ruby@packages.altlinux.org>')
         expect {
            Maintainer.import_from_changelogname('Ruby Maintainers Team <ruby@packages.altlinux.org>')
         }.not_to change(Maintainer::Team, :count)
      end
   end
end
