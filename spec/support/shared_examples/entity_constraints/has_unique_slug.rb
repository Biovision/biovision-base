require 'rails_helper'

RSpec.shared_examples_for 'has_unique_slug' do
  let(:model) { described_class.to_s.underscore.to_sym }

  describe 'validation' do
    it 'fails with non-unique slug' do
      subject.valid?
      create model, slug: subject.slug
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end
  end
end
