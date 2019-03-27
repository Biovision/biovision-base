# frozen_string_literal: true

# Mailer for sending feedback requests
class FeedbackMailer < ApplicationMailer
  # @param [Integer] id
  def new_feedback_request(id)
    @entity = FeedbackRequest.find_by(id: id)

    receiver = BiovisionComponent['contact'].receive('feedback_receiver')

    mail to: receiver unless @entity.nil? || receiver.blank?
  end
end
