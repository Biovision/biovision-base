class CreateBiovisionComponents < ActiveRecord::Migration[5.2]
  def up
    unless BiovisionComponent.table_exists?
      create_table :biovision_components do |t|
        t.timestamps
        t.string :slug, null: false
        t.json :settings, null: false, default: {}
      end

      add_index :biovision_components, :slug, unique: true
    end

    unless BiovisionParameter.table_exists?
      create_table :biovision_parameters do |t|
        t.timestamps
        t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.boolean :deletable, default: true, null: false
        t.string :slug, null: false
        t.string :name
        t.text :value
        t.text :description
      end
    end

    seed_items
  end

  def down
    drop_table :biovision_parameters if BiovisionParameter.table_exists?
    drop_table :biovision_components if BiovisionComponent.table_exists?
  end

  private

  def seed_items
    create_registration_component

    component  = BiovisionComponent.create!(slug: 'contact')
    collection = {
      feedback_receiver: ['Адрес обратной связи', 'info@example.com', 'На этот адрес приходят запросы обратной связи'],
      email:             ['E-mail', 'info@example.com', 'Адрес электронной почты для отображения в контактах'],
      phone:             ['Телефон', '', 'Телефон для отображения в контактах'],
      address:           ['Адрес', '', 'Адрес для отображения в контактах']
    }
    create_parameters(component, collection)
  end

  def create_registration_component
    slug     = 'registration'
    settings = {
      open: true,
      invite_only: false,
      confirm_email: false
    }

    BiovisionComponent.create!(slug: slug, settings: settings)
  end

  # @param [BiovisionComponent] component
  # @param [Hash] collection
  def create_parameters(component, collection)
    collection.each do |slug, data|
      attributes = {
        biovision_component: component,
        slug:                slug,
        deletable:           false,
        name:                data[0],
        value:               data[1],
        description:         data[2]
      }

      BiovisionParameter.create!(attributes)
    end
  end
end
