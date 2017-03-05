require 'rails_helper'

RSpec.shared_examples_for 'index_entities_with_required_privilege' do
  describe 'get index' do
    before :each do
      allow(subject).to receive(:require_privilege)
      allow(entity.class).to receive(:page_for_administration)
      get :index
    end

    it_behaves_like 'required_user_privilege'
    it_behaves_like 'http_success'

    it 'sends :page_for_administration to entity class' do
      expect(entity.class).to have_received(:page_for_administration)
    end
  end
end
