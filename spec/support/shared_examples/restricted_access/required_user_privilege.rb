require 'rails_helper'

RSpec.shared_examples_for 'required_user_privilege' do
  it 'requires privilege' do
    expect(subject).to have_received(:require_privilege).with(required_privilege)
  end
end
