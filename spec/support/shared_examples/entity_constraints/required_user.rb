require 'rails_helper'

RSpec.shared_examples_for 'required_user' do
  describe 'validation' do
    it 'fails without user' do
      subject.user = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:user)
    end
  end
end
