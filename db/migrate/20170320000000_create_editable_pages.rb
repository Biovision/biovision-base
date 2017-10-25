class CreateEditablePages < ActiveRecord::Migration[5.1]
  def up
    unless EditablePage.table_exists?
      create_table :editable_pages do |t|
        t.timestamps
        t.string :slug, null: false
        t.string :name, null: false
        t.string :url
        t.string :image
        t.string :title, default: '', null: false
        t.string :keywords, default: '', null: false
        t.string :description, default: '', null: false
        t.text :body, default: '', null: false
      end

      EditablePage.create(slug: 'index', name: 'Главная страница')
      EditablePage.create(slug: 'about', name: 'О проекте')
      EditablePage.create(slug: 'tos', name: 'Пользовательское соглашение')
    end
  end

  def down
    if EditablePage.table_exists?
      drop_table :editable_pages
    end
  end
end
