require 'rails_helper'

RSpec.shared_examples_for 'has_valid_factory' do
  let(:model) { described_class.to_s.underscore.to_sym }

  it 'has valid factory' do
    entity = build model
    expect(entity).to be_valid
  end
end
