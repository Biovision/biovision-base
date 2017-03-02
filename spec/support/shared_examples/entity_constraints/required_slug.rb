require 'rails_helper'

RSpec.shared_examples_for 'required_slug' do
  describe 'validation' do
    it 'fails without slug' do
      subject.slug = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end
  end
end
