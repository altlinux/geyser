# frozen_string_literal: true

require 'rails_helper'

describe Changelog do
   let(:branch) { create(:branch, :with_paths) }
   let(:group) { create(:group) }
   let(:srpm) { create(:srpm, branch: branch, group: group) }
   let(:maintainers) { Maintainer.joins(:changelogs).distinct.as_json(only: %i(name login)) }
   let(:spkg) { Package.find_by_id(srpm.package.id) }
   let(:changelog) { spkg.changelog }

   it { is_expected.to be_an(ApplicationRecord) }

   context 'Associations' do
      it { is_expected.to belong_to(:package).class_name('Package::Src').optional }
      it { is_expected.to belong_to(:maintainer).optional }
      it { is_expected.to belong_to(:spkg).class_name('Package::Src').optional }
   end

   context 'Validation' do
      it { is_expected.to validate_presence_of(:at) }
      it { is_expected.to validate_presence_of(:text) }
   end

   context 'Delegations' do
      it { is_expected.to delegate_method(:shown_name).to(:maintainer).with_prefix(true).allow_nil }
      it { is_expected.to delegate_method(:locked_email).to(:maintainer).with_prefix(true).allow_nil }
   end

   context 'Behaviour' do
      it 'should import changelogs' do
         file = './spec/data/catpkt-1.0-alt5.src.rpm'

         expect { Changelog.import_from(Rpm::Base.new(file), srpm.package) }
            .to change(Changelog, :count).by(5)
         expect(maintainers).to match_array(["name"=>"Igor Zubkov", "login"=>"icesik"])
         expect(spkg.changelog).to eq(Changelog.first)
         expect(changelog.spkg).to eq(spkg)
      end
   end
end
