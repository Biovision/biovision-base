require 'rails_helper'

RSpec.shared_examples_for 'entity_creator' do
  it 'inserts entity into table' do
    expect(action).to change(entity.class, :count).by(1)
  end
end
