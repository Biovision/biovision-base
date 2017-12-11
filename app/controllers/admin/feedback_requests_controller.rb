class Admin::FeedbackRequestsController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: [:index]

  # get /admin/feedback_requests
  def index
    @collection = FeedbackRequest.page_for_administration(current_page)
  end

  private

  def restrict_access
    require_privilege :feedback_manager
  end

  def set_entity
    @entity = FeedbackRequest.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find feedback request')
    end
  end
end
