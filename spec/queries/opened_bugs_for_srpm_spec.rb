# frozen_string_literal: true

require 'rails_helper'

describe OpenedBugsForSrpm do
   let(:srpm) { create(:srpm) }

   subject { described_class.new(spkg: srpm.package, branch: srpm.branch) }

   it { is_expected.to be_a(Rectify::Query) }

   describe '#initialize' do
      let(:scope) { Issue::Bug.all }

      before do
         #
         # AllBugsForSrpm.new(srpm) => scope
         #
         expect(AllBugsForSrpm).to receive(:new).with(spkg: srpm.package, branch: srpm.branch).and_return(scope)
      end

      its(:scope) { is_expected.to eq(scope) }
   end

   describe '#decorate' do
      let(:scope) { Issue::Bug.all }

      before do
         #
         # AllBugsForSrpm.new(srpm) => scope
         #
         expect(AllBugsForSrpm).to receive(:new).with(spkg: srpm.package, branch: srpm.branch).and_return(scope)

      end

      before do
         #
         # subject.query.decorate
         #
         expect(subject).to receive(:query)
      end

      specify { expect { subject.decorate }.not_to raise_error }
   end
end
