class CreateLinkBlocks < ActiveRecord::Migration[5.2]
  def up
    unless LinkBlock.table_exists?
      create_table :link_blocks do |t|
        t.timestamps
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.boolean :visible, default: true, null: false
        t.string :slug, null: false
        t.string :title
        t.text :lead
        t.text :footer_text
      end

      create_privilege
    end
  end

  def down
    if LinkBlock.table_exists?
      drop_table :link_blocks
    end
  end

  def create_privilege
    unless Privilege.where(slug: 'content_manager').exists?
      Privilege.create! slug: 'content_manager', name: 'Контент-менеджер'
    end
  end
end
