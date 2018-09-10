# frozen_string_literal: true

require 'rails_helper'

describe Group do
  it { should be_a(ApplicationRecord) }

  context 'Associations' do
    it { is_expected.to belong_to(:branch) }

    it { is_expected.to have_many(:packages) }
    it { is_expected.to have_many(:rpms).through(:packages) }
  end

  it { should validate_presence_of(:name) }

  it 'should return full group name on #full_name' do
    branch = create(:branch)
    Group.import(branch, 'System/Configuration/Boot and Init')
    expect(Group.all.last.full_name).to eq('System/Configuration/Boot and Init')
  end

  it 'should import group "Shells"' do
    branch = create(:branch)
    Group.import(branch, 'Shells')
    expect(Group.all.count).to eq(1)
    expect(Group.all.first.branch_id).to eq(branch.id)
    expect(Group.all.first.name).to eq('Shells')
    expect(Group.all.first.parent_id).to be_nil
  end

  it 'should import group "Archiving/Backup"' do
    branch = create(:branch)
    Group.import(branch, 'Archiving/Backup')

    groups = Group.all.order('name ASC')

    expect(groups.count).to eq(2)

    expect(groups.first.branch_id).to eq(branch.id)
    expect(groups.first.name).to eq('Archiving')
    expect(groups.first.parent_id).to be_nil

    expect(groups.second.branch_id).to eq(branch.id)
    expect(groups.second.name).to eq('Backup')
    expect(groups.second.parent_id).to eq(Group.all.first.id)
  end

  it 'should import group "System/Configuration/Boot and Init"' do
    branch = create(:branch)
    Group.import(branch, 'System/Configuration/Boot and Init')

    groups = Group.all.order('name ASC')

    expect(groups.count).to eq(3)

    expect(groups.first.branch_id).to eq(branch.id)
    expect(groups.first.name).to eq('Boot and Init')
    expect(groups.first.parent_id).to eq(groups.second.id)

    expect(groups.second.branch_id).to eq(branch.id)
    expect(groups.second.name).to eq('Configuration')
    expect(groups.second.parent_id).to eq(groups.third.id)

    expect(groups.third.branch_id).to eq(branch.id)
    expect(groups.third.name).to eq('System')
    expect(groups.third.parent_id).to be_nil
  end

  it 'should return group instance with id for "Boot and Init"' do
    branch = create(:branch)
    Group.import(branch, 'System/Configuration/Boot and Init')
    expect(Group.in_branch(branch, 'System/Configuration/Boot and Init').name).to eq('Boot and Init')
  end
end
