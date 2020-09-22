require 'rails_helper'

RSpec.describe BrowsersController, type: :controller do
  let!(:entity) { create :browser }
  let(:required_privilege) { :administrator }
  let(:valid_create_params) { { browser: attributes_for(:browser) } }
  let(:valid_update_params) { { id: entity.id, browser: { name: 'Changed' } } }
  let(:invalid_create_params) { { browser: { name: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, browser: { name: ' ' } } }
  let(:path_after_create) { admin_browser_path(id: entity.class.last.id) }
  let(:path_after_update) { admin_browser_path(id: entity.id) }
  let(:path_after_destroy) { admin_browsers_path }

  before :each do
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'new_entity_with_required_privilege'
  it_behaves_like 'create_entity_with_required_privilege'
  it_behaves_like 'edit_lockable_entity_with_required_privilege'
  it_behaves_like 'update_lockable_entity_with_required_privilege'
  it_behaves_like 'delete_lockable_entity_with_required_privilege'
end
