class CreateEditablePages < ActiveRecord::Migration[5.1]
  def up
    unless EditablePage.table_exists?
      create_table :editable_pages do |t|
        t.timestamps
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.integer :priority, limit: 2, default: 1, null: false
        t.string :slug, null: false
        t.string :name, null: false
        t.string :nav_group
        t.string :url
        t.string :image
        t.string :title, default: '', null: false
        t.string :keywords, default: '', null: false
        t.string :description, default: '', null: false
        t.text :body, default: '', null: false
      end

      pages = {
        index: { ru: 'Главная страница', en: 'Main page' },
        about: { ru: 'О проекте', en: 'About' },
        tos: { ru: 'Пользовательское соглашение', en: 'Terms of service' },
      }

      pages.each do |slug, names|
        Language.each do |language|
          EditablePage.create(slug: slug, name: names[language.code.to_sym], language: language)
        end
      end
    end
  end

  def down
    if EditablePage.table_exists?
      drop_table :editable_pages
    end
  end
end
