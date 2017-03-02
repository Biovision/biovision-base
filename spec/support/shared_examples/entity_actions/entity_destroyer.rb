require 'rails_helper'

RSpec.shared_examples_for 'entity_destroyer' do
  it 'removes entity from database' do
    expect(action).to change(entity.class, :count).by(-1)
  end
end
