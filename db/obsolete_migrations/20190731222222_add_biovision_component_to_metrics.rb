# frozen_string_literal: true

# Add reference to biovision_component from metrics
class AddBiovisionComponentToMetrics < ActiveRecord::Migration[5.2]
  def up
    return if column_exists? :metrics, :biovision_component_id

    add_reference :metrics, :biovision_component, foreign_key: { on_update: :cascade, on_delete: :cascade }
  end

  def down
    # No rollback needed
  end
end
