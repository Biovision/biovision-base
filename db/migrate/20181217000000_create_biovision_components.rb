# frozen_string_literal: true

# Table and default items for Biovision components
class CreateBiovisionComponents < ActiveRecord::Migration[5.2]
  def up
    create_components_table unless BiovisionComponent.table_exists?

    seed_items
  end

  def down
    drop_table :biovision_components if BiovisionComponent.table_exists?
  end

  private

  def create_components_table
    create_table :biovision_components, comment: 'Biovision component' do |t|
      t.timestamps
      t.integer :priority, limit: 2, default: 1, null: false
      t.string :slug, null: false
      t.jsonb :settings, null: false, default: {}
      t.jsonb :parameters, null: false, default: {}
    end

    add_index :biovision_components, :slug, unique: true
  end

  def seed_items
    create_registration_component
    create_contact_component
    create_users_component
    create_content_component
  end

  def create_registration_component
    settings = {
      open: true,
      invite_only: false,
      confirm_email: false,
      use_invites: false,
      require_email: false,
      invite_count: 5
    }

    BiovisionComponent.create!(slug: 'registration', settings: settings)
  end

  def create_contact_component
    parameters = {
      email: 'info@example.com',
      phone: '',
      address: ''
    }

    settings = {
      feedback_receiver: 'info@example.com'
    }

    BiovisionComponent.create!(slug: 'contact', parameters: parameters, settings: settings)
  end

  def create_users_component
    BiovisionComponent.create!(slug: 'users')
  end

  def create_content_component
    BiovisionComponent.create!(slug: 'content')
  end
end
