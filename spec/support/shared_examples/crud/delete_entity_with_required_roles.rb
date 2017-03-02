require 'rails_helper'

RSpec.shared_examples_for 'delete_entity_with_required_roles' do
  describe 'delete destroy' do
    before :each do
      allow(subject).to receive(:require_role)
      allow(entity.class).to receive(:find_by).and_return(entity)
      delete :destroy, params: { id: entity.id }
    end

    it_behaves_like 'required_roles'
    it_behaves_like 'entity_finder'
    it_behaves_like 'entity_deleter'

    it 'redirects to list of entities' do
      expect(response).to redirect_to(path_after_destroy)
    end
  end
end
