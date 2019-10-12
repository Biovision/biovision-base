# frozen_string_literal: true

# Tables for editable pages and blocks
class CreateEditablePages < ActiveRecord::Migration[5.1]
  def up
    create_editable_pages unless EditablePage.table_exists?
  end

  def down
    drop_table :editable_pages if EditablePage.table_exists?
  end

  private

  def create_editable_pages
    create_table :editable_pages, comment: 'Editable page' do |t|
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

    seed_pages
  end

  def seed_pages
    pages = {
      index: ['', { ru: 'Главная страница', en: 'Main page' }],
      about: ['about', { ru: 'О проекте', en: 'About' }],
      tos: ['tos', { ru: 'Пользовательское соглашение', en: 'Terms of service' }],
      privacy: ['privacy', { ru: 'Политика конфиденциальности', en: 'Privacy' }],
      contact: ['contact', { ru: 'Контакты', en: 'Contact' }]
    }

    pages.each do |slug, data|
      url = data[0]
      names = data[1]
      Language.where(active: true).each do |language|
        code = language.code
        prefix = code.to_sym == I18n.default_locale ? '' : "/#{code}"
        EditablePage.create(
          slug: slug,
          name: names[code.to_sym],
          language: language,
          url: "#{prefix}/#{url}"
        )
      end
    end
  end
end
