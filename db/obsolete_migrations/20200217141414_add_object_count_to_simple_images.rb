# frozen_string_literal: true

# Add object counter for simple images table
class AddObjectCountToSimpleImages < ActiveRecord::Migration[5.2]
  def up
    return if column_exists? :simple_images, :object_count

    add_column :simple_images, :object_count, :integer, default: 0, null: false
  end

  def down
    # No rollback needed
  end
end
