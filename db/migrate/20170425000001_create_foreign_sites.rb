class CreateForeignSites < ActiveRecord::Migration[5.1]
  def up
    unless ForeignSite.table_exists?
      create_table :foreign_sites do |t|
        t.timestamps
        t.string :slug, null: false
        t.string :name, null: false
        t.integer :foreign_users_count, default: 0, null: false
      end
    end
  end

  def down
    if ForeignSite.table_exists?
      drop_table :foreign_sites
    end
  end
end
