class CreateUserProfiles < ActiveRecord::Migration[5.1]
  def up
    unless UserProfile.table_exists?
      create_table :user_profiles do |t|
        t.timestamps
        t.references :user, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
        t.integer :gender, limit: 2
        t.date :birthday
        t.string :name
        t.string :patronymic
        t.string :surname
      end
    end
  end

  def down
    if UserProfile.table_exists?
      drop_table :user_profiles
    end
  end
end
