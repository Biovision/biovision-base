# frozen_string_literal: true

# Update tables to match version 181217
class UpdateFields181217 < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:metrics, :biovision_component_id)
      add_reference :metrics, :biovision_component, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end

    if column_exists?(:users, :profile_data)
      User.order('id asc').each do |user|
        user.data['profile'] = user.profile_data
        user.save!
      end
    end
  end

  def down
    # No rollback needed
  end
end
