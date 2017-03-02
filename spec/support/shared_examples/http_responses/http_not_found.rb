require 'rails_helper'

RSpec.shared_examples_for 'http_not_found' do
  it 'responds with HTTP status 404' do
    expect(response).to have_http_status(:not_found)
  end
end
