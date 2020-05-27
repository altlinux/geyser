# frozen_string_literal: true

require 'rails_helper'

describe AllBugsForSrpm do
   let(:srpm) { create(:srpm) }

   subject { described_class.new(spkg: srpm.package, branch: srpm.branch) }

   it { is_expected.to be_a(Rectify::Query) }

   describe '#initialize' do
      its(:spkg) { is_expected.to eq(srpm.package) }
      its(:branch) { is_expected.to eq(srpm.branch) }
   end

   describe '#query' do
      let(:branch_paths) { srpm.branch.branch_paths.select(:id) }

      before do
         #
         # Bug.where(repo_name: reponames).order(bug_id: :desc)
         #
         expect(Issue::Bug).to receive(:s).with(srpm.package) do
            double.tap do |a|
               expect(a).to receive(:where).with(branch_path_id: branch_paths) do
                  double.tap do |a|
                     expect(a).to receive(:order).with(Arel.sql("no::integer DESC"))
                  end
               end
            end
         end
      end

      specify { expect { subject.query }.not_to raise_error }
   end

   describe '#decorate' do
      before do
         #
         # subject.query.decorate
         #
         expect(subject).to receive(:query)
      end

      specify { expect { subject.decorate }.not_to raise_error }
   end
end
