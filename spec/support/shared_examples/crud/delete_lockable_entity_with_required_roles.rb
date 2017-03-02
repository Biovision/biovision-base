require 'rails_helper'

RSpec.shared_examples_for 'delete_lockable_entity_with_required_roles' do
  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity.id } } }

    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:find_by).and_return(entity)
    end

    context 'when entity is locked' do
      before :each do
        allow(entity).to receive(:locked?).and_return(true)
        action.call
      end

      it_behaves_like 'required_roles'
      it_behaves_like 'entity_finder'

      it 'does not delete entity' do
        entity.reload
        expect(entity).not_to be_deleted
      end

      it 'redirects to entity page' do
        expect(response).to redirect_to(path_after_update)
      end
    end

    context 'when entity is not locked' do
      before :each do
        allow(entity).to receive(:locked?).and_return(false)
        action.call
      end

      it_behaves_like 'required_roles'
      it_behaves_like 'entity_finder'
      it_behaves_like 'entity_deleter'

      it 'redirects to list of entities' do
        expect(response).to redirect_to(path_after_destroy)
      end
    end
  end
end
