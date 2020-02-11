# frozen_string_literal: true

# Controllers for logged-in users only
class ProfileController < ApplicationController
  before_action :restrict_access

  protected

  def restrict_access
    restrict_anonymous_access
  end
end
