require 'rails_helper'

RSpec.shared_examples_for 'create_entity_without_required_roles' do
  describe 'post create' do
    before :each do
      allow(subject).to receive(:require_role)
    end

    context 'when parameters are valid' do
      let(:action) { -> { post :create, params: valid_create_params } }

      it_behaves_like 'entity_creator'

      context 'restrictions and response' do
        before :each do
          action.call
        end

        it_behaves_like 'no_roles_required'

        it 'redirects to created entity' do
          expect(response).to redirect_to(path_after_create)
        end
      end
    end

    context 'when parameters are invalid' do
      before :each do
        post :create, params: invalid_create_params
      end

      it_behaves_like 'http_bad_request'
    end
  end
end
