class CreateStoredValues < ActiveRecord::Migration[5.1]
  def up
    unless StoredValue.table_exists?
      create_table :stored_values do |t|
        t.timestamps
        t.string :slug, null: false
        t.string :value
        t.string :name
        t.string :description
      end
    end
  end

  def down
    if StoredValue.table_exists?
      drop_table :stored_values
    end
  end
end
