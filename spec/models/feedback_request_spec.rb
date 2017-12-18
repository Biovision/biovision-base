require 'rails_helper'

RSpec.describe FeedbackRequest, type: :model do
  subject { build :feedback_request }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  it_behaves_like 'limits_max_name_length', 100

  describe 'validation' do
    it 'fails with too long email' do
      subject.email = 'noreply@' + 'a.' * 120 + '.example.com'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:email)
    end

    it 'fails with malformed email' do
      subject.email = 'invalid email'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:email)
    end

    it 'fails with too long phone' do
      subject.phone = '1' * 31
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:phone)
    end

    it 'fails with too long comment' do
      subject.comment = 'A' * 5001
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:comment)
    end
  end
end
