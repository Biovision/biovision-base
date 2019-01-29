# frozen_string_literal: true

# Processing feedback requests
class FeedbackRequestsController < ApplicationController
  # post /feedback_requests
  def create
    @entity = FeedbackRequest.new(creation_parameters)
    if params[:agree]
      show_result
    else
      save_entity
    end
  end

  private

  def save_entity
    if @entity.save
      show_result
      FeedbackMailer.new_feedback_request(@entity.id).deliver_later
    else
      redirect_to root_path
    end
  end

  def show_result
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
      format.js
    end
  end

  def creation_parameters
    parameters = params.require(:feedback_request).permit(FeedbackRequest.creation_parameters)
    parameters.merge(tracking_for_entity)
  end
end
