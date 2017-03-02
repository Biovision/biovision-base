require 'rails_helper'

RSpec.describe MetricValue, type: :model do
  subject { build :metric_value }

  it_behaves_like 'has_valid_factory'

  describe 'validation' do
    it 'fails without metric' do
      subject.metric = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:metric)
    end

    it 'fails without time' do
      subject.time = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:time)
    end

    it 'fails without quantity' do
      subject.quantity = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:quantity)
    end

    it 'passes with zero quantity' do
      subject.quantity = 0
      expect(subject).to be_valid
    end
  end
end
