class AddConsentToUsers < ActiveRecord::Migration[5.1]
  def up
    unless column_exists? :users, :consent
      add_column :users, :consent, :boolean, default: false, null: false

      User.all.each { |user| user.update! consent: true }
    end
  end

  def down
    #   No rollback needed
  end
end
