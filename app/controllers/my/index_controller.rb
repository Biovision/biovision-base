class My::IndexController < ApplicationController
  before_action :restrict_anonymous_access

  # get /my
  def index
  end
end
