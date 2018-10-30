class CreateEditablePages < ActiveRecord::Migration[5.1]
  def up
    return if EditablePage.table_exists?

    create_table :editable_pages do |t|
      t.timestamps
      t.references :language, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :visible, default: true, null: false
      t.integer :priority, limit: 2, default: 1, null: false
      t.string :slug, null: false
      t.string :name, null: false
      t.string :nav_group
      t.string :url
      t.string :image
      t.string :image_alt_text
      t.string :meta_title, default: '', null: false
      t.string :meta_keywords, default: '', null: false
      t.string :meta_description, default: '', null: false
      t.text :body, default: '', null: false
    end

    create_pages
  end

  def down
    drop_table :editable_pages if EditablePage.table_exists?
  end

  def create_pages
    pages = {
      index:   ['', { ru: 'Главная страница', en: 'Main page' }],
      about:   ['about', { ru: 'О проекте', en: 'About' }],
      tos:     ['tos', { ru: 'Пользовательское соглашение', en: 'Terms of service' }],
      privacy: ['privacy', { ru: 'Политика конфиденциальности', en: 'Privacy' }],
      contact: ['contact', { ru: 'Контакты', en: 'Contact' }]
    }

    pages.each do |slug, data|
      url   = data[0]
      names = data[1]
      Language.all.each do |language|
        EditablePage.create(
          slug:     slug,
          name:     names[language.code.to_sym],
          language: language,
          url:      "/#{language.code}/#{url}"
        )
      end
    end
  end
end
