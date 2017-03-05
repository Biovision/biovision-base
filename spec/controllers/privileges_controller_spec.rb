require 'rails_helper'

RSpec.describe PrivilegesController, type: :controller do
  let!(:entity) { create :privilege }
  let(:required_privilege) { :administrator }
  let(:valid_create_params) { { privilege: attributes_for(:privilege) } }
  let(:valid_update_params) { { id: entity.id, privilege: { name: 'Changed' } } }
  let(:invalid_create_params) { { privilege: { name: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, privilege: { name: ' ' } } }
  let(:path_after_create) { admin_privilege_path(entity.class.last.id) }
  let(:path_after_update) { admin_privilege_path(entity.id) }
  let(:path_after_destroy) { admin_privileges_path }

  before :each do
    allow(subject).to receive(:require_privilege)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'new_entity_with_required_privilege'
  it_behaves_like 'create_entity_with_required_privilege'
  it_behaves_like 'edit_lockable_entity_with_required_privilege'
  it_behaves_like 'update_lockable_entity_with_required_privilege'
  it_behaves_like 'delete_lockable_entity_with_required_privilege'
end
