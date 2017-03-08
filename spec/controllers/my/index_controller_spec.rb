require 'rails_helper'

RSpec.describe My::IndexController, type: :controller do
  before :each do
    allow(subject).to receive(:restrict_anonymous_access)
  end

  describe 'get index' do
    before(:each) { get :index }

    it_behaves_like 'page_for_user'
    it_behaves_like 'http_success'
  end
end
