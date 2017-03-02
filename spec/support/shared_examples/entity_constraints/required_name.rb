require 'rails_helper'

RSpec.shared_examples_for 'required_name' do
  describe 'validation' do
    it 'fails without name' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end
  end
end
