require 'rails_helper'

RSpec.shared_examples_for 'stripping_name' do
  describe 'before validation' do
    it 'strips name' do
      subject.name = '  Aaa  '
      subject.valid?
      expect(subject.name).to eq('Aaa')
    end
  end
end
