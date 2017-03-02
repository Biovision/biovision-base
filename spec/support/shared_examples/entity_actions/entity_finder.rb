require 'rails_helper'

RSpec.shared_examples_for 'entity_finder' do
  it 'finds entity by criteria' do
    expect(entity.class).to have_received(:find_by)
  end
end
