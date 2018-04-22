class ProfileController < ApplicationController
  before_action :restrict_access

  protected

  def restrict_access
    restrict_anonymous_access
  end
end
