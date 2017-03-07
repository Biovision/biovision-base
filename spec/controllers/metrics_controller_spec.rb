require 'rails_helper'

RSpec.describe MetricsController, type: :controller do
  let!(:entity) { create :metric }
  let(:required_privilege) { :metrics_manager }
  let(:valid_update_params) { { id: entity.id, metric: { name: 'Changed' } } }
  let(:invalid_create_params) { { metric: { name: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, metric: { name: ' ' } } }
  let(:path_after_create) { admin_metric_path(entity.class.last.id) }
  let(:path_after_update) { admin_metric_path(entity.id) }
  let(:path_after_destroy) { admin_metrics_path }

  it_behaves_like 'edit_entity_with_required_privilege'

  describe 'patch update' do
    before :each do
      allow(subject).to receive(:require_privilege)
      allow(entity.class).to receive(:find_by).and_return(entity)
    end

    context 'when parameters are valid' do
      before :each do
        patch :update, params: valid_update_params
      end

      it_behaves_like 'required_user_privilege'
      it_behaves_like 'entity_finder'

      it 'redirects to entity' do
        expect(response).to redirect_to(path_after_update)
      end
    end
  end
end
