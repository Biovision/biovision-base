require 'rails_helper'

RSpec.describe Code, type: :model do
  subject { build :code }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_owner'

  describe 'new instance' do
    it 'generates code body' do
      expect(Code.new.body).not_to be_nil
    end
  end

  describe 'validation' do
    it 'fails without body' do
      subject.body = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end

    it 'fails for non-unique body' do
      create :code, body: subject.body
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:body)
    end
  end

  describe '::recovery_for_user' do
    let(:user) { create :user }
    let(:action) { -> { Code.recovery_for_user user } }

    context 'when non-activated recovery exists' do
      before :each do
        subject.category = Code.categories[:recovery]
        subject.user     = user
        subject.save!
      end

      it 'returns existing code' do
        expect(action.call).to eq(subject)
      end

      it 'does not insert new code' do
        expect(action).not_to change(Code, :count)
      end
    end

    context 'when recovery does not exist' do
      it 'creates new code' do
        expect(action).to change(Code, :count)
      end

      it 'returns new code' do
        expect(action.call).to be_a(Code)
      end
    end

    it 'returns non-activated code' do
      expect(action.call).not_to be_activated
    end

    it 'sets email of user as payload' do
      expect(action.call.payload).to eq(user.email)
    end
  end

  describe '::confirmation_for_user' do
    let(:user) { create :user }
    let(:action) { -> { Code.confirmation_for_user user } }

    context 'when non-activated confirmation exists' do
      before :each do
        subject.category = Code.categories[:confirmation]
        subject.user     = user
        subject.save!
      end

      it 'returns existing code' do
        expect(action.call).to eq(subject)
      end

      it 'does not insert new code' do
        expect(action).not_to change(Code, :count)
      end
    end

    context 'when confirmation does not exist' do
      it 'creates new code' do
        expect(action).to change(Code, :count)
      end

      it 'returns new code' do
        expect(action.call).to be_a(Code)
      end
    end

    it 'returns non-activated code' do
      expect(action.call).not_to be_activated
    end

    it 'sets email of user as payload' do
      expect(action.call.payload).to eq(user.email)
    end
  end
end