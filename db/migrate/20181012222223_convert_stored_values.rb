class ConvertStoredValues < ActiveRecord::Migration[5.2]
  def up
    return unless StoredValue.table_exists?

    slug = 'feedback_receiver'

    Biovision::Component['contact'][slug] = StoredValue.receive(slug)
  end

  def down
    # No rollback needed
  end
end
