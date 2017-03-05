require 'rails_helper'

RSpec.shared_examples_for 'no_privileges_required' do
  it 'does not require any privileges' do
    expect(subject).not_to have_received(:require_privilege)
  end
end
