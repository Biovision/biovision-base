class ApplicationController < ActionController::Base
  include Biovision::Base::PrivilegeMethods

  protect_from_forgery with: :exception
end
