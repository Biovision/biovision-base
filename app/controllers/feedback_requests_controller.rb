class FeedbackRequestsController < ApplicationController
  # post /feedback_requests
  def create
    @entity = FeedbackRequest.new(creation_parameters)
    if @entity.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end

      FeedbackMailer.new_feedback_request(@entity.id).deliver_later
    else
      redirect_to root_path
    end
  end

  private

  def creation_parameters
    parameters = params.require(:feedback_request).permit(FeedbackRequest.creation_parameters)
    parameters.merge(tracking_for_entity)
  end
end
