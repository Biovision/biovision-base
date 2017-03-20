require 'rails_helper'

RSpec.describe Admin::EditablePagesController, type: :controller do
  let!(:entity) { create :editable_page }
  let(:required_privilege) { :chief_editor }

  it_behaves_like 'index_entities_with_required_privilege'
  it_behaves_like 'show_entity_with_required_privilege'
end
