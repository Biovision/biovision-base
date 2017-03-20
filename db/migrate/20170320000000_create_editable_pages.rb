class CreateEditablePages < ActiveRecord::Migration[5.0]
  def up
    unless EditablePage.table_exists?
      create_table :editable_pages do |t|
        t.timestamps
        t.string :slug, null: false
        t.string :name, null: false
        t.string :image
        t.string :title, default: '', null: false
        t.string :keywords, default: '', null: false
        t.string :description, default: '', null: false
        t.text :body, default: '', null: false
      end
    end
  end

  def down
    if EditablePage.table_exists?
      drop_table :editable_pages
    end
  end
end
