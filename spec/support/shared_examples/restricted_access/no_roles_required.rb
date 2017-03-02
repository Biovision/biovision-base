require 'rails_helper'

RSpec.shared_examples_for 'no_roles_required' do
  it 'does not require any roles' do
    expect(subject).not_to have_received(:require_role)
  end
end
