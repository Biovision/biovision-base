class CreateLanguages < ActiveRecord::Migration[5.1]
  def up
    unless Language.table_exists?
      create_table :languages do |t|
        t.timestamps
        t.integer :users_count, default: 0, null: false
        t.integer :priority, limit: 2, default: 1, null: false
        t.string :slug, null: false
        t.string :code, null: false
      end

      Language.create!(code: 'ru', slug: 'russian')
      Language.create!(code: 'en', slug: 'english')
    end
  end

  def down
    if Language.table_exists?
      drop_table :languages
    end
  end
end
