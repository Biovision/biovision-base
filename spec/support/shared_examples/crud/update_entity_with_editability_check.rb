require 'rails_helper'

RSpec.shared_examples_for 'update_entity_with_editability_check' do
  describe 'patch update' do
    let(:user) { create :user }

    before :each do
      allow(subject).to receive(:current_user).and_return(user)
      allow(entity.class).to receive(:find_by).and_return(entity)
      allow(entity).to receive(:update).and_call_original
    end

    context 'when entity is not editable by user' do
      before :each do
        allow(entity).to receive(:editable_by?).and_return(false)
        patch :update, params: valid_update_params
      end

      it_behaves_like 'entity_finder'

      it 'checks editablilty' do
        expect(entity).to have_received(:editable_by?).with(user)
      end

      it 'does not update entity' do
        expect(entity).not_to have_received(:update)
      end

      it 'redirects to entity' do
        expect(response).to redirect_to(path_after_update)
      end
    end

    context 'when entity is editable by user' do
      before :each do
        allow(entity).to receive(:editable_by?).and_return(true)
      end

      context 'when parameters are valid' do
        before :each do
          patch :update, params: valid_update_params
        end

        it_behaves_like 'entity_finder'

        it 'checks editablilty' do
          expect(entity).to have_received(:editable_by?).with(user)
        end

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

        it_behaves_like 'entity_finder'
        it_behaves_like 'http_bad_request'

        it 'checks editablilty' do
          expect(entity).to have_received(:editable_by?).with(user)
        end

        it 'tries to update entity' do
          expect(entity).to have_received(:update)
        end
      end
    end
  end
end
