class CreateFeedbackRequests < ActiveRecord::Migration[5.1]
  def up
    unless FeedbackRequest.table_exists?
      create_table :feedback_requests do |t|
        t.timestamps
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.boolean :processed
        t.string :name
        t.string :email
        t.string :phone
        t.text :comment
      end

      Privilege.create(slug: 'feedback_manager', name: 'Менеджер обратной связи')
      StoredValue.create(slug: 'feedback_receiver', value: 'support@example.com', name: 'Адрес для запросов обратной связи', description: 'На этот адрес будут отправляться запросы обратной связи')
    end
  end

  def down
    if FeedbackRequest.table_exists?
      drop_table :feedback_requests
    end
  end
end
