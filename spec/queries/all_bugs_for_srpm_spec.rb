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
      let(:reponames) { Package.select(:name).distinct }
      let(:branch_paths) { BranchPath.all }

      before { expect(subject).to receive(:reponames).and_return(reponames) }

      before do
         #
         # Bug.where(repo_name: reponames).order(bug_id: :desc)
         #
         expect(Issue::Bug).to receive(:where).with(repo_name: reponames, branch_path_id: branch_paths) do
            double.tap do |a|
               expect(a).to receive(:order).with(no: :desc)
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

   # private methods

   describe '#reponames' do
      before do
         #
         # srpm.packages.pluck(:name).flatten.sort.uniq
         #
         expect(srpm.package).to receive(:packages) do
            double.tap do |a|
               expect(a).to receive(:select).with(:name) do
                  double.tap do |b|
                     expect(b).to receive(:distinct)
                  end
               end
            end
         end
      end

      specify { expect { subject.send(:reponames) }.not_to raise_error }
   end
end
