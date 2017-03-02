require 'rails_helper'

RSpec.shared_examples_for 'http_bad_request' do
  it 'responds with HTTP status 400' do
    expect(response).to have_http_status(:bad_request)
  end
end
