class AddReferralLinkToUsers < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:users, :referral_link)
      add_column :users, :referral_link, :string

      seed_links
    end
  end

  def down
    # No need to rollback
  end

  private

  def seed_links
    User.order('id asc').each do |user|
      next unless user.referral_link.blank?
      user.update(referral_link: SecureRandom.alphanumeric(12))
    end
  end
end
