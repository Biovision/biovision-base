require 'rails_helper'

RSpec.shared_examples_for 'has_owner' do
  let(:model) { described_class.to_s.underscore.to_sym }

  describe '#owned_by?' do
    let(:owner) { create :user }
    let(:entity) { create model, user: owner }

    it 'returns true for the same user as in entity' do
      expect(entity).to be_owned_by(owner)
    end

    it 'returns false for other user than in entity' do
      expect(entity).not_to be_owned_by(User.new)
    end

    it 'returns false for nil' do
      expect(entity).not_to be_owned_by(nil)
    end
  end
end
