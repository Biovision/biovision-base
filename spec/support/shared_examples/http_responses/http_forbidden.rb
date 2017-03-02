require 'rails_helper'

RSpec.shared_examples_for 'http_forbidden' do
  it 'responds with HTTP status 403' do
    expect(response).to have_http_status(:forbidden)
  end
end
