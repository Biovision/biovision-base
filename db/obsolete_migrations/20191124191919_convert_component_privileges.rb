# frozen_string_literal: true

# Convert component-user privileges to new storage schema
class ConvertComponentPrivileges < ActiveRecord::Migration[5.2]
  def up
    BiovisionComponentUser.order('id asc').each do |link|
      next if link.data.key?('privileges')

      privilege_names = link.data.keys
      link.data = {
        privileges: privilege_names,
        settings: {}
      }
      link.save!
    end
  end

  def down
    # No rollback needed
  end
end
