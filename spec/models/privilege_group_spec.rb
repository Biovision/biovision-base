require 'rails_helper'

RSpec.describe PrivilegeGroup, type: :model do
  subject { build :privilege_group }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'has_unique_slug'
  it_behaves_like 'required_name'
  it_behaves_like 'required_slug'

  describe 'validation' do
    it 'fails with too long description' do
      subject.description = 'a' * (PrivilegeGroup::DESCRIPTION_LIMIT + 1)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:description)
    end
  end
end
