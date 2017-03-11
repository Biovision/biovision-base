require 'rails_helper'

RSpec.describe Admin::TokensController, type: :controller do
  let!(:entity) { create :token }
  let(:required_privilege) { :administrator }

  it_behaves_like 'index_entities_with_required_privilege'
  it_behaves_like 'show_entity_with_required_privilege'
  it_behaves_like 'toggle_entity_parameter_with_required_privilege'
end
