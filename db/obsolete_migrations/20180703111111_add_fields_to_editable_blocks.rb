class AddFieldsToEditableBlocks < ActiveRecord::Migration[5.2]
  def up
    unless column_exists? :editable_blocks, :description
      add_column :editable_blocks, :description, :string
    end
    unless column_exists? :editable_blocks, :raw_output
      add_column :editable_blocks, :raw_output, :boolean, default: false, null: false
    end
  end

  def down
    # No rollback needed
  end
end
