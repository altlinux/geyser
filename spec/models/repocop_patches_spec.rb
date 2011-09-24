require 'spec_helper'

describe RepocopPatch do
  it { should validate_presence_of :name }
  it { should validate_presence_of :version }
  it { should validate_presence_of :release }
  it { should validate_presence_of :url }

  it { should have_db_index :name }

  it "should import repocops patches list from url" do
    page = `cat spec/data/prometeus2-patches.sql`
    FakeWeb.register_uri(:get,
                         "http://repocop.altlinux.org/pub/repocop/prometeus2/prometeus2-patches.sql",
                         response: page)
    expect{
      RepocopPatch.update_repocop_patches
      }.to change{ RepocopPatch.count }.from(0).to(1)
  end
end
