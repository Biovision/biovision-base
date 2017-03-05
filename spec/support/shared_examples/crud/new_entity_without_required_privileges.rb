require 'rails_helper'

RSpec.shared_examples_for 'new_entity_without_required_privileges' do
  describe 'get new' do
    before :each do
      allow(subject).to receive(:require_privilege)
      get :new
    end

    it_behaves_like 'no_privileges_required'
    it_behaves_like 'http_success'
  end
end
