class AddFieldsToFeedbackRequests < ActiveRecord::Migration[5.1]
  def up
    add_column :feedback_requests, :image, :string unless column_exists?(:feedback_requests, :image)
    add_column :feedback_requests, :comment, :text unless column_exists?(:feedback_requests, :comment)
  end

  def down
  #   No need to rollback
  end
end
