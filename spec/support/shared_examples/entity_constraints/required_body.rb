require 'rails_helper'

RSpec.shared_examples_for 'required_body' do
  describe 'validation' do
    it 'fails without body' do
      subject.body = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end
  end
end
