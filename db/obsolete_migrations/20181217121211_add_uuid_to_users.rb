# frozen_string_literal: true

# Adding UUID column for users
class AddUuidToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :uuid, :uuid unless column_exists?(:users, :uuid)
  end

  def down
    # No rollback
  end
end
