require 'rails_helper'

RSpec.describe Privilege, type: :model do
  subject { build :privilege }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_unique_slug'
  it_behaves_like 'required_name'

  describe 'validation' do
    it 'fails with non-unique name for parent' do
      create :privilege, parent: subject.parent, name: subject.name.upcase
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'fails with too long description' do
      subject.description = 'a' * (Privilege::DESCRIPTION_LIMIT + 1)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:description)
    end
  end
end
