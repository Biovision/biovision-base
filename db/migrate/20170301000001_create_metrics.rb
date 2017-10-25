class CreateMetrics < ActiveRecord::Migration[5.1]
  def up
    unless Metric.table_exists?
      create_table :metrics do |t|
        t.timestamps
        t.boolean :incremental, default: false, null: false
        t.boolean :start_with_zero, default: false, null: false
        t.boolean :show_on_dashboard, default: true, null: false
        t.integer :default_period, limit: 2, default: 7, null: false
        t.integer :value, default: 0, null: false
        t.integer :previous_value, default: 0, null: false
        t.string :name, null: false
        t.string :description, default: '', null: false
      end
    end
  end

  def down
    if Metric.table_exists?
      drop_table :metrics
    end
  end
end
