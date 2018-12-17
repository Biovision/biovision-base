class AddProfileDataToUsers < ActiveRecord::Migration[5.1]
  def up
    unless column_exists? :users, :birthday
      add_column :users, :birthday, :date
    end
    unless column_exists? :users, :data
      add_column :users, :data, :json, null: false, default: { profile: {} }
    end

    copy_data if UserProfile.table_exists?
  end

  def down
    # no rollback
  end

  private

  def copy_data
    ignore = %w[id created_at updated_at user_id birthday]
    UserProfile.order('user_id asc').each do |profile|
      data = {
        data: { profile: profile.attributes.reject { |a| ignore.include?(a) } }
      }
      if profile.attributes.key?('birthday')
        data[:birthday] = profile.birthday
      end
      profile.user.update!(data)
    end
  end
end
