require 'rails_helper'

RSpec.describe UserPrivilege, type: :model do
  subject { build :user_privilege }

  let(:super_user) { create :user, super_user: true }
  let(:other_user) { create :user }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'required_user'
  it_behaves_like 'required_privilege'

  describe 'validation' do
    it 'fails with non-unique pair' do
      create :user_privilege, user: subject.user, privilege: subject.privilege
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:privilege_id)
    end
  end

  describe '::user_has_privilege?' do
    let(:name) { subject.privilege.slug }

    before(:each) do
      subject.save
    end

    it 'returns false for nil' do
      expect(UserPrivilege.user_has_privilege?(nil, name)).not_to be
    end

    it 'returns false for foreign privilege' do
      expect(UserPrivilege.user_has_privilege?(other_user, name)).not_to be
    end

    it 'returns true for super user' do
      expect(UserPrivilege.user_has_privilege?(super_user, name)).to be
    end

    it 'returns true for direct privilege' do
      expect(UserPrivilege.user_has_privilege?(subject.user, name)).to be
    end

    it 'returns true for nested privilege' do
      child = create :privilege, parent: subject.privilege
      subject.privilege.cache_children!
      expect(UserPrivilege.user_has_privilege?(subject.user, child.slug)).to be
    end
  end

  describe '::user_has_any_privilege?' do
    before(:each) do
      subject.save
    end

    it 'returns false for nil' do
      expect(UserPrivilege.user_has_any_privilege?(nil)).not_to be
    end

    it 'returns false for user without privileges' do
      expect(UserPrivilege.user_has_any_privilege?(other_user)).not_to be
    end

    it 'returns true for super user' do
      expect(UserPrivilege.user_has_any_privilege?(super_user)).to be
    end

    it 'returns true for user with any privilege' do
      expect(UserPrivilege.user_has_any_privilege?(subject.user)).to be
    end
  end

  describe '::user_in_group?' do
    before(:each) do
      subject.save
    end

    it 'returns false for nil' do
      expect(UserPrivilege.user_in_group?(nil, :any)).not_to be
    end

    it 'returns false for user outside group' do
      expect(UserPrivilege.user_in_group?(subject.user, :any)).not_to be
    end

    it 'returns true for super user' do
      expect(UserPrivilege.user_in_group?(super_user, :any)).to be
    end

    it 'returns true for user inside group' do
      link = create :privilege_group_privilege, privilege: subject.privilege
      name = link.privilege_group.slug
      expect(UserPrivilege.user_in_group?(subject.user, name)).to be
    end
  end
end
