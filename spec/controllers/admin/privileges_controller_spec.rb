require 'rails_helper'

RSpec.describe Admin::PrivilegesController, type: :controller do
  let!(:entity) { create :privilege }
  let(:required_privilege) { :administrator }
  let(:locker_privilege) { :administrator }

  it_behaves_like 'show_entity_with_required_privilege'
  it_behaves_like 'lock_entity_with_required_privilege'
  it_behaves_like 'unlock_entity_with_required_privilege'

  describe 'get index' do
    before :each do
      allow(subject).to receive(:require_privilege)
      get :index
    end

    it_behaves_like 'required_user_privilege'
    it_behaves_like 'http_success'
  end

  describe 'get users' do
    pending
  end
end
