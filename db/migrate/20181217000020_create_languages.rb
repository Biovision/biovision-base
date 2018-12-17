# frozen_string_literal: true

# Table for languages
class CreateLanguages < ActiveRecord::Migration[5.1]
  def up
    return if Language.table_exists?

    create_table :languages, comment: 'Language l10n, i18n, etc.' do |t|
      t.timestamps
      t.boolean :active, default: true, null: false
      t.integer :priority, limit: 2, default: 1, null: false
      t.integer :users_count, default: 0, null: false
      t.string :slug, null: false
      t.string :code, null: false
    end

    seed_items
  end

  def down
    drop_table :languages if Language.table_exists?
  end

  private

  def seed_items
    Language.create!(code: 'ru', slug: 'russian')
    Language.create!(code: 'en', slug: 'english')
  end
end
