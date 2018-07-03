class CreateEditableBlocks < ActiveRecord::Migration[5.2]
  def up
    unless EditableBlock.table_exists?
      create_table :editable_blocks do |t|
        t.timestamps
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.boolean :visible, default: true, null: false
        t.boolean :raw_output, default: false, null: false
        t.string :slug, null: false
        t.string :name
        t.string :description
        t.string :image
        t.string :title
        t.text :lead
        t.text :body
        t.text :footer
      end

      add_default_blocks
    end
  end

  def down
    if EditableBlock.table_exists?
      drop_table :editable_blocks
    end
  end

  private

  def add_default_blocks
    EditableBlock.create(
      slug: 'counters',
      name: 'Счётчики для сайта',
      description: 'Используется только основной текст, всегда «как есть»',
      raw_output: true
    )
  end
end
