require 'rails_helper'

RSpec.shared_examples_for 'edit_entity_with_editability_check' do
  describe 'get edit' do
    let(:user) { create :user }
    let(:action) { -> { get :edit, params: { id: entity.id } } }

    before :each do
      allow(subject).to receive(:current_user).and_return(user)
      allow(entity.class).to receive(:find_by).and_return(entity)
    end

    context 'when entity is editable by user' do
      before :each do
        allow(entity).to receive(:editable_by?).and_return(true)
        action.call
      end

      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'

      it 'checks editability' do
        expect(entity).to have_received(:editable_by?).with(user)
      end
    end

    context 'when entity is not editable by user' do
      before :each do
        allow(entity).to receive(:editable_by?).and_return(false)
        action.call
      end

      it_behaves_like 'entity_finder'

      it 'redirects to entity page' do
        expect(response).to redirect_to(path_after_update)
      end

      it 'checks editability' do
        expect(entity).to have_received(:editable_by?).with(user)
      end
    end
  end
end
