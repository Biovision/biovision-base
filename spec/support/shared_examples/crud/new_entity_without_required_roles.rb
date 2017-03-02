require 'rails_helper'

RSpec.shared_examples_for 'new_entity_without_required_roles' do
  describe 'get new' do
    before :each do
      allow(subject).to receive(:require_role)
      get :new
    end

    it_behaves_like 'no_roles_required'
    it_behaves_like 'http_success'
  end
end
