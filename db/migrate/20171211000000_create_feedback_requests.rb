class CreateFeedbackRequests < ActiveRecord::Migration[5.1]
  def up
    unless FeedbackRequest.table_exists?
      create_table :feedback_requests do |t|
        t.timestamps
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.boolean :processed
        t.boolean :consent, default: false, null: false
        t.string :name
        t.string :email
        t.string :phone
        t.string :image
        t.text :comment
      end
    end
  end

  def down
    if FeedbackRequest.table_exists?
      drop_table :feedback_requests
    end
  end
end
