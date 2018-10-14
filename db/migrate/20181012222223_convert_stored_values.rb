class ConvertStoredValues < ActiveRecord::Migration[5.2]
  def up
    return unless StoredValue.table_exists?

    slug = 'feedback_receiver'

    BiovisionComponent['contact'][slug] = StoredValue.receive(slug)
  end

  def down
    # No rollback needed
  end
end
