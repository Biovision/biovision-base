class AddConsentToFeedbackRequests < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:feedback_requests, :consent)
      add_column :feedback_requests, :consent, :boolean, default: false, null: false

      FeedbackRequest.order('id asc').each do |entity|
        entity.update! consent: true
      end
    end
  end

  def down
    # No need to rollback
  end
end
