require 'rails_helper'

RSpec.describe PrivilegeGroupsController, type: :controller do
  let!(:entity) { create :privilege_group }
  let(:required_privilege) { :administrator }
  let(:valid_create_params) { { privilege_group: attributes_for(:privilege_group) } }
  let(:valid_update_params) { { id: entity.id, privilege_group: { name: 'Changed' } } }
  let(:invalid_create_params) { { privilege_group: { name: ' ' } } }
  let(:invalid_update_params) { { id: entity.id, privilege_group: { name: ' ' } } }
  let(:path_after_create) { admin_privilege_group_path(entity.class.last.id) }
  let(:path_after_update) { admin_privilege_group_path(entity.id) }
  let(:path_after_destroy) { admin_privilege_groups_path }

  before :each do
    allow(subject).to receive(:require_privilege)
    allow(entity.class).to receive(:find_by).and_return(entity)
  end

  it_behaves_like 'new_entity_with_required_privilege'
  it_behaves_like 'create_entity_with_required_privilege'
  it_behaves_like 'edit_entity_with_required_privilege'
  it_behaves_like 'update_entity_with_required_privilege'
  it_behaves_like 'destroy_entity_with_required_privilege'
end
