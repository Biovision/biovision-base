class AddNewFields171026 < ActiveRecord::Migration[5.1]
  def up
    unless column_exists?(:editable_pages, :url)
      change_table :editable_pages do |t|
        t.integer :priority, limit: 2, default: 1, null: false
        t.string :url
        t.string :nav_group
      end
    end

    unless column_exists?(:users, :balance)
      change_table :users do |t|
        t.integer :balance, default: 0, null: false
      end
    end
  end

  def down
  #   No need to rollback
  end
end
