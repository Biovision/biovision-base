class FeedbackMailer < ApplicationMailer
  # @param [Integer] id
  def new_feedback_request(id)
    @entity = FeedbackRequest.find_by(id: id)

    receiver = Biovision::Component['contact']['feedback_receiver']

    mail to: receiver unless @entity.nil? || receiver.blank?
  end
end
