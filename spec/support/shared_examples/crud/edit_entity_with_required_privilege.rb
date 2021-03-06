require 'rails_helper'

RSpec.shared_examples_for 'edit_entity_with_required_privilege' do
  describe 'get edit' do
    before :each do
      # allow(subject).to receive(:require_privilege)
      allow(entity.class).to receive(:find_by).and_return(entity)
      get :edit, params: { id: entity.id }
    end

    it_behaves_like 'required_user_privilege'
    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'
  end
end
