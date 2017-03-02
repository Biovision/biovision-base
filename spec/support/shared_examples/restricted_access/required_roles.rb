require 'rails_helper'

RSpec.shared_examples_for 'required_roles' do
  it 'requires roles' do
    expect(subject).to have_received(:require_role).with(*Array(required_roles))
  end
end
