require 'rails_helper'

RSpec.describe Admin::MetricsController, type: :controller do
  let!(:entity) { create :metric }
  let(:required_privilege) { :metrics_manager }

  it_behaves_like 'index_entities_with_required_privilege'
  it_behaves_like 'show_entity_with_required_privilege'
end
