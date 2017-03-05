require 'rails_helper'

RSpec.shared_examples_for 'required_privilege' do
  describe 'validation' do
    it 'fails without privilege' do
      subject.privilege = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:privilege)
    end
  end
end
