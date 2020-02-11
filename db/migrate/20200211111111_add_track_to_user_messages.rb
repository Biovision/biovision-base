# frozen_string_literal: true

# Add UA and IP to user messages
class AddTrackToUserMessages < ActiveRecord::Migration[5.2]
  def up
    return if column_exists? :user_messages, :agent_id

    add_reference :user_messages, :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
    add_column :user_messages, :ip, :inet
  end

  def down
    # No rollback needed
  end
end
