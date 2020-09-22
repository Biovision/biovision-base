require 'rails_helper'

RSpec.shared_examples_for 'new_entity_with_required_privilege' do
  describe 'get new' do
    before :each do
      # allow(subject).to receive(:require_privilege)
      get :new
    end

    it_behaves_like 'required_user_privilege'
    it_behaves_like 'http_success'
  end
end
