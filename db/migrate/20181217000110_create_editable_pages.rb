# frozen_string_literal: true

# Tables for editable pages and blocks
class CreateEditablePages < ActiveRecord::Migration[5.1]
  def up
    create_editable_pages unless EditablePage.table_exists?
    create_link_blocks unless LinkBlock.table_exists?
    create_link_block_items unless LinkBlockItem.table_exists?
    create_editable_blocks unless EditableBlock.table_exists?
  end

  def down
    drop_table :editable_blocks if EditableBlock.table_exists?
    drop_table :link_block_items if LinkBlockItem.table_exists?
    drop_table :link_blocks if LinkBlock.table_exists?
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

  def create_link_blocks
    create_table :link_blocks, comment: 'Editable block of links' do |t|
      t.timestamps
      t.references :language, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :visible, default: true, null: false
      t.string :slug, null: false
      t.string :title
      t.text :lead
      t.text :footer_text
    end
  end

  def create_link_block_items
    create_table :link_block_items, comment: 'Link in editable links block' do |t|
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

  def create_editable_blocks
    create_table :editable_blocks, comment: 'Editable block' do |t|
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

  def seed_pages
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

  def add_default_blocks
    EditableBlock.create(
      slug: 'counters',
      name: 'Счётчики для сайта',
      description: 'Используется только основной текст, всегда «как есть»',
      raw_output: true
    )
  end
end
