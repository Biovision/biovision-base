class My::IndexController < ApplicationController
  before_action :restrict_anonymous_access

  # layout 'profile'

  # get /my
  def index
  end
end
