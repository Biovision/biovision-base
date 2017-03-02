class CreateAgents < ActiveRecord::Migration[5.0]
  def up
    unless Agent.table_exists?
      create_table :agents do |t|
        t.timestamps
        t.references :browser, foreign_key: true, on_update: :cascade, on_delete: :nullify
        t.boolean :bot, null: false, default: false
        t.boolean :mobile, null: false, default: false
        t.boolean :active, null: false, default: true
        t.boolean :locked, null: false, default: false
        t.boolean :deleted, null: false, default: false
        t.string :name, null: false, index: true
      end
    end
  end

  def down
    if Agent.table_exists?
      drop_table :agents
    end
  end
end
