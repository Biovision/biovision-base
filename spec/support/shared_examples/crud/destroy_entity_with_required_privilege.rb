require 'rails_helper'

RSpec.shared_examples_for 'destroy_entity_with_required_privilege' do
  describe 'delete destroy' do
    let(:action) { -> { delete :destroy, params: { id: entity.id } } }

    before :each do
      allow(subject).to receive(:require_privilege)
      allow(entity.class).to receive(:find_by).and_return(entity)
    end

    context 'database change' do
      it_behaves_like 'entity_destroyer'
    end

    context 'restrictions, finding and redirect' do
      before :each do
        action.call
      end

      it_behaves_like 'required_user_privilege'
      it_behaves_like 'entity_finder'

      it 'redirects to list of entities' do
        expect(response).to redirect_to(path_after_destroy)
      end
    end
  end
end
