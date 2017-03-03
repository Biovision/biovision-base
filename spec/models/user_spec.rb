require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build :user }

  it_behaves_like 'has_valid_factory'

  describe 'before save' do
    it 'normalizes screen name to slug' do
      subject.screen_name = 'New_User_In_Test'
      subject.save
      expect(subject.slug).to eq('new_user_in_test')
    end
  end

  describe 'validation' do
    it 'fails without screen name' do
      subject.screen_name = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:screen_name)
    end

    it 'fails with invalid screen name' do
      subject.screen_name = ' Invalid Screen Name! '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:screen_name)
    end

    it 'fails with non-unique case-insensitive screen name' do
      create(:user, screen_name: subject.screen_name.upcase)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:screen_name)
    end

    it 'fails without email' do
      subject.email = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:email)
    end

    it 'fails with invalid email' do
      subject.email = ' invalid email '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:email)
    end

    it 'fails with non-unique case-insensitive email' do
      create(:user, email: subject.email.upcase)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:email)
    end
  end
end
