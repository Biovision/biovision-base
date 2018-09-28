class AddLanguageToModels < ActiveRecord::Migration[5.1]
  def up
    unless column_exists?(:users, :language_id)
      change_table :users do |t|
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
      end
    end

    unless column_exists?(:editable_pages, :language_id)
      change_table :editable_pages do |t|
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :cascade }
      end
    end

    unless column_exists?(:feedback_requests, :language_id)
      change_table :feedback_requests do |t|
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
      end
    end
  end

  def down
    #   No rollback needed
  end
end
