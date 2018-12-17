# frozen_string_literal: true

# Browsers and Agents tables
class CreateBrowsers < ActiveRecord::Migration[5.1]
  def up
    create_browsers unless Browser.table_exists?
    create_agents unless Agent.table_exists?
  end

  def down
    drop_table :agents if Agent.table_exists?
    drop_table :browsers if Browser.table_exists?
  end

  private

  def create_browsers
    create_table :browsers, comment: 'Browser for grouping user agents' do |t|
      t.timestamps
      t.boolean :bot, null: false, default: false
      t.boolean :mobile, null: false, default: false
      t.boolean :active, null: false, default: true
      t.integer :agents_count, default: 0, null: false
      t.string :name, index: true, null: false
    end
  end

  def create_agents
    create_table :agents, comment: 'User agent' do |t|
      t.timestamps
      t.references :browser, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :bot, null: false, default: false
      t.boolean :mobile, null: false, default: false
      t.boolean :active, null: false, default: true
      t.string :name, null: false, index: true
    end
  end
end
