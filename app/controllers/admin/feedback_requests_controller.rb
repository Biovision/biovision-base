# frozen_string_literal: true

# Handling feedback requests
class Admin::FeedbackRequestsController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/feedback_requests
  def index
    @collection = FeedbackRequest.page_for_administration(current_page)
  end

  private

  def component_class
    Biovision::Components::ContactComponent
  end

  def restrict_access
    error = 'Managing feedback requests is not allowed'
    handle_http_401(error) unless component_handler.allow?('feedback_manager')
  end

  def set_entity
    @entity = FeedbackRequest.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find feedback request')
    end
  end
end
