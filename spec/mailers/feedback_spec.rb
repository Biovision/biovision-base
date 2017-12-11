require "rails_helper"

RSpec.describe FeedbackMailer, type: :mailer do
  describe "new_feedback_request" do
    let(:mail) { FeedbackMailer.new_feedback_request }

    it "renders the headers" do
      expect(mail.subject).to eq("New feedback request")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
