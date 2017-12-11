class FeedbackMailer < ApplicationMailer
  # @param [Integer] id
  def new_feedback_request(id)
    @entity = FeedbackRequest.find_by(id: id)

    receiver = StoredValue.receive('feedback_receiver')

    mail to: receiver unless @entity.nil? || receiver.nil?
  end
end
