# frozen_string_literal: true

# Table for feedback requests
class CreateFeedbackRequests < ActiveRecord::Migration[5.1]
  def up
    return if FeedbackRequest.table_exists?

    create_table :feedback_requests, comment: 'Feedback request' do |t|
      t.timestamps
      t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.boolean :processed, default: false, null: false
      t.boolean :consent, default: false, null: false
      t.string :name
      t.string :email
      t.string :phone
      t.string :image
      t.text :comment
    end
  end

  def down
    drop_table :feedback_requests if FeedbackRequest.table_exists?
  end
end
