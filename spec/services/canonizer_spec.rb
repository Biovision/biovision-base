require File.expand_path('../../rails_helper.rb', __FILE__)

RSpec.describe Canonizer do
  describe '::canonize' do
    it 'converts text to lower case' do
      expect(Canonizer.canonize('WOW')).to eq('wow')
    end

    it 'removes spaces' do
      expect(Canonizer.canonize('o m g')).to eq('omg')
    end

    it 'removes everything except letters and numbers' do
      expect(Canonizer.canonize('?1sы - !+—')).to eq('1sы')
    end

    it 'keeps letter ё' do
      expect(Canonizer.canonize('Ёё')).to eq('ёё')
    end

    it 'returns original string if it has only non-canonical characters' do
      expect(Canonizer.canonize('?!')).to eq('?!')
    end
  end
end
