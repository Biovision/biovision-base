class AddImageAltTextToEditablePage < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:editable_pages, :image_alt_text)
      add_column :editable_pages, :image_alt_text, :string
    end
  end

  def down
    # no rollback needed
  end
end
