require 'rails_helper'

describe Specfile do
  it { should be_a(ApplicationRecord) }

  it { should belong_to(:srpm) }

  it { should validate_presence_of(:spec) }

  it 'should import spec file' do
    branch = create(:branch)
    group = create(:group, branch_id: branch.id)
    srpm = create(:srpm, branch_id: branch.id, group_id: group.id)
    file = 'openbox-3.4.11.1-alt1.1.1.src.rpm'

    expect(Specfile).to receive(:`).with("rpm -qp --queryformat=\"[%{FILEFLAGS} %{FILENAMES}\n]\" \"#{ file }\" | grep \"32 \" | sed -e 's/32 //'").and_return('openbox.spec')
    expect(Specfile).to receive(:`).with("rpm2cpio \"#{ file }\" | cpio -i --quiet --to-stdout \"openbox.spec\"").and_return('qwerty')

    expect { Specfile.import(file, srpm) }
      .to change(Specfile, :count).by(1)

    expect(srpm.specfile).not_to be_nil
    expect(srpm.specfile.spec).to eq('qwerty')

    specfile = Specfile.first
    expect(specfile.srpm).not_to be_nil
  end
end
