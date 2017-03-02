require 'rails_helper'

RSpec.shared_examples_for 'required_image' do
  describe 'validation' do
    it 'fails without image' do
      subject.image = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:image)
    end
  end
end
