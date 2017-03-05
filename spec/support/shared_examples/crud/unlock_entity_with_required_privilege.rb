require 'rails_helper'

RSpec.shared_examples_for 'unlock_entity_with_required_privilege' do
  describe 'delete unlock' do
    before :each do
      allow(subject).to receive(:require_privilege)
      allow(entity.class).to receive(:find_by).and_return(entity)
      allow(entity).to receive(:update!).and_call_original
      delete :unlock, params: { id: entity.id }
    end

    it_behaves_like 'entity_finder'
    it_behaves_like 'http_success'

    it 'requires locker privilege' do
      expect(subject).to have_received(:require_privilege).with(locker_privilege)
    end

    it 'locks entity' do
      expect(entity).to have_received(:update!).with(locked: false)
    end
  end
end
