require 'rails_helper'

RSpec.shared_examples_for 'update_lockable_entity_with_required_roles' do
  describe 'patch update' do
    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:find_by).and_return(entity)
      allow(entity).to receive(:update).and_call_original
    end

    context 'when entity is locked' do
      before :each do
        allow(entity).to receive(:locked?).and_return(true)
        patch :update, params: valid_update_params
      end

      it_behaves_like 'required_roles'
      it_behaves_like 'entity_finder'

      it 'does not update entity' do
        expect(entity).not_to have_received(:update)
      end

      it 'redirects to entity' do
        expect(response).to redirect_to(path_after_update)
      end
    end

    context 'when entity is not locked' do
      before :each do
        allow(entity).to receive(:locked?).and_return(false)
      end

      context 'when parameters are valid' do
        before :each do
          patch :update, params: valid_update_params
        end

        it_behaves_like 'required_roles'
        it_behaves_like 'entity_finder'

        it 'tries to update entity' do
          expect(entity).to have_received(:update)
        end

        it 'redirects to entity' do
          expect(response).to redirect_to(path_after_update)
        end
      end

      context 'when parameters are invalid' do
        before :each do
          patch :update, params: invalid_update_params
        end

        it_behaves_like 'required_roles'
        it_behaves_like 'entity_finder'
        it_behaves_like 'http_bad_request'

        it 'tries to update entity' do
          expect(entity).to have_received(:update)
        end
      end
    end
  end
end
