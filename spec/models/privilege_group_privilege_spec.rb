require 'rails_helper'

RSpec.describe PrivilegeGroup, type: :model do
  subject { build :privilege_group_privilege }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_privilege'

  describe 'validation' do
    it 'fails without privilege_group' do
      subject.privilege_group = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:privilege_group)
    end

    it 'fails with non-unique pair' do
      create :privilege_group_privilege, privilege_group: subject.privilege_group, privilege: subject.privilege
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:privilege_id)
    end
  end
end
