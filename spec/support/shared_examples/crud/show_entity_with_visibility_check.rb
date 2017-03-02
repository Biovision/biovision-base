require 'rails_helper'

RSpec.shared_examples_for 'show_entity_with_visibility_check' do
  describe 'get show' do
    let(:user) { create :user }
    let(:action) { -> { get :show, params: { id: entity.id } } }

    before :each do
      allow(subject).to receive(:current_user).and_return(user)
      allow(entity.class).to receive(:find_by).and_return(entity)
    end

    context 'when entity is visible to user' do
      before :each do
        allow(entity).to receive(:visible_to?).and_return(true)
        action.call
      end

      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'

      it 'checks visibility' do
        expect(entity).to have_received(:visible_to?).with(user)
      end
    end

    context 'when entity is not visible to user' do
      before :each do
        allow(entity).to receive(:visible_to?).and_return(false)
        action.call
      end

      it_behaves_like 'http_not_found'

      it 'checks visibility' do
        expect(entity).to have_received(:visible_to?).with(user)
      end
    end
  end
end
