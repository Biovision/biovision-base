require 'rails_helper'

RSpec.shared_examples_for 'page_for_user' do
  it 'restricts anonymous access' do
    expect(subject).to have_received(:restrict_anonymous_access)
  end
end
