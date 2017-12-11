# Preview all emails at http://localhost:3000/rails/mailers/feedback
class FeedbackPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/feedback/new_feedback_request
  def new_feedback_request
    FeedbackMailer.new_feedback_request(FeedbackRequest.last.id)
  end

end
