require 'rails_helper'

RSpec.shared_examples_for 'toggle_lockable_entity_parameter_with_required_privilege' do
  describe 'post toggle' do
    before :each do
      allow(subject).to receive(:current_user)
      allow(entity.class).to receive(:find_by).and_return(entity)
      allow(entity).to receive(:toggle_parameter).and_return(true)
    end

    context 'when entity is locked' do
      before :each do
        allow(entity).to receive(:locked?).and_return(true)
        post :toggle, params: { parameter: :foo }
      end

      it_behaves_like 'entity_finder'
      it_behaves_like 'http_forbidden'
      it_behaves_like 'required_user_privilege'

      it 'does not toggle parameter' do
        expect(entity).not_to have_received(:toggle_parameter)
      end
    end

    context 'when entity is not locked' do
      before :each do
        allow(entity).to receive(:locked?).and_return(false)
        post :toggle, params: { parameter: :foo }
      end

      it_behaves_like 'entity_finder'
      it_behaves_like 'http_success'
      it_behaves_like 'required_user_privilege'

      it 'toggles parameter' do
        expect(entity).to have_received(:toggle_parameter)
      end
    end
  end
end
