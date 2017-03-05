require 'rails_helper'

RSpec.shared_examples_for 'entity_deleter' do
  it 'marks entity as deleted' do
    entity.reload
    expect(entity).to be_deleted
  end
end
