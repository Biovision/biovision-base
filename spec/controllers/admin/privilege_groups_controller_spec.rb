require 'rails_helper'

RSpec.describe Admin::PrivilegeGroupsController, type: :controller do
  let!(:entity) { create :privilege_group }
  let(:required_privilege) { :administrator }

  it_behaves_like 'index_entities_with_required_privilege'
  it_behaves_like 'show_entity_with_required_privilege'

  describe 'get show' do
    before :each do
      allow(subject).to receive(:require_privilege)
      allow(Privilege).to receive(:ordered_by_name)
      get :show, params: { id: entity.id }
    end

    it 'gets administrative page of agents' do
      expect(Privilege).to have_received(:ordered_by_name)
    end
  end
end
