class UpdateEditablePagesMeta < ActiveRecord::Migration[5.2]
  # Rename meta fields and add visibility
  def up
    table = EditablePage.table_name

    %i[description keywords title].each do |column|
      next unless column_exists?(table, column)

      rename_column table, column, "meta_#{column}"
    end

    return if column_exists?(table, :visible)

    add_column table, :visible, :boolean, default: true, null: false
  end

  def down
    # No rollback needed
  end
end
