require 'rails_helper'

RSpec.describe Admin::BrowsersController, type: :controller do
  let!(:entity) { create :browser }
  let(:required_privilege) { :administrator }

  it_behaves_like 'index_entities_with_required_privilege'
  it_behaves_like 'show_entity_with_required_privilege'

  describe 'get show' do
    before :each do
      allow(subject).to receive(:require_privilege)
      allow(Agent).to receive(:page_for_administration)
      get :show, params: { id: entity.id }
    end

    it 'gets administrative page of agents' do
      expect(Agent).to have_received(:page_for_administration)
    end
  end
end
