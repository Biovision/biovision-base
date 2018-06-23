class CreateLinkBlockItems < ActiveRecord::Migration[5.2]
  def up
    create_table :link_block_items do |t|
      t.timestamps
      t.references :link_block, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :visible, default: true, null: false
      t.integer :priority, limit: 2, default: 1, null: false
      t.string :slug
      t.string :image
      t.string :image_alt_text
      t.string :title
      t.string :button_text
      t.string :button_url
      t.text :body
    end
  end

  def down
    if LinkBlockItem.table_exists?
      drop_table :LinkBlockItem
    end
  end
end
