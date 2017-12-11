require 'rails_helper'

# В блоке используется именно максимально допустимая длина, так как иначе
# фраза будет звучать не логично.
RSpec.shared_examples_for 'limits_max_name_length' do |limit|
  describe 'validation' do
    it 'fails with too long name' do
      subject.name = 'A' * (limit.to_i + 1)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end
  end
end
