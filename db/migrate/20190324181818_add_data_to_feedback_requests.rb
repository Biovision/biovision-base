# frozen_string_literal: true

# Adding data column to feedback requests if it does not exist
class AddDataToFeedbackRequests < ActiveRecord::Migration[5.2]
  def up
    return if column_exists?(:feedback_requests, :data)

    add_column :feedback_requests, :data, :jsonb, default: {}, null: false
  end

  def down
    # No rollback needed
  end
end
