require 'rails_helper'

RSpec.describe MediaFolder, type: :model do
  subject { build :media_folder }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  describe 'after initialize' do
    it 'generates UUID' do
      expect(MediaFolder.new.uuid).not_to be_nil
    end
  end

  describe 'after create' do
    before :each do
      subject.save!
    end

    it 'caches parents' do
      entity = create(:media_folder, parent: subject)
      expect(entity.parents_cache).to eq(subject.id.to_s)
    end

    it 'caches parent children' do
      entity = create(:media_folder, parent: subject)
      expect(subject.children_cache).to eq([entity.id])
    end
  end

  describe 'before validation' do
    it 'sets depth' do
      subject.save!
      entity = build :media_folder, parent: subject
      entity.valid?
      expect(entity.depth).to eq(subject.depth + 1)
    end
  end

  describe 'validation' do
    it 'fails with blank name' do
      subject.name = ' '
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'fails with non-unique name for same parent' do
      create(:media_folder, parent: subject.parent, name: subject.name)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'passes with non-unique name for different parents' do
      subject.parent = create(:media_folder, name: subject.name)
      expect(subject).to be_valid
    end

    it 'fails with too long name' do
      subject.name = 'A' * 150
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'fails when parent is too deep' do
      parent = create(:media_folder)
      allow(parent).to receive(:depth).and_return(MediaFolder::MAX_DEPTH)
      subject.parent = parent
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:parent)
    end
  end
end
