# frozen_string_literal: true

# Tables for Biovision components
class CreateBiovisionComponents < ActiveRecord::Migration[5.2]
  def up
    create_components_table unless BiovisionComponent.table_exists?
    create_parameters_table unless BiovisionParameter.table_exists?

    seed_items
  end

  def down
    drop_table :biovision_parameters if BiovisionParameter.table_exists?
    drop_table :biovision_components if BiovisionComponent.table_exists?
  end

  private

  def create_components_table
    create_table :biovision_components, comment: 'Biovision component' do |t|
      t.timestamps
      t.string :slug, null: false
      t.json :settings, null: false, default: {}
    end

    add_index :biovision_components, :slug, unique: true
  end

  def create_parameters_table
    create_table :biovision_parameters, comment: 'Biovision component parameter' do |t|
      t.timestamps
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :deletable, default: true, null: false
      t.string :slug, null: false
      t.text :value
    end
  end

  def seed_items
    create_registration_component

    component  = BiovisionComponent.create!(slug: 'contact')
    collection = {
      feedback_receiver: 'info@example.com',
      email:             'info@example.com',
      phone:             '',
      address:           ''
    }
    create_parameters(component, collection)
  end

  def create_registration_component
    slug     = 'registration'
    settings = {
      open:          true,
      invite_only:   false,
      confirm_email: false,
      use_invites:   false,
      require_email: false,
      invite_count:  5
    }

    BiovisionComponent.create!(slug: slug, settings: settings)
  end

  # @param [BiovisionComponent] component
  # @param [Hash] collection
  def create_parameters(component, collection)
    collection.each do |slug, value|
      attributes = {
        biovision_component: component,
        slug:                slug,
        deletable:           false,
        value:               value,
      }

      BiovisionParameter.create!(attributes)
    end
  end
end
