class CreateBiovisionComponents < ActiveRecord::Migration[5.2]
  def up
    unless Biovision::Component.table_exists?
      create_table :biovision_components do |t|
        t.timestamps
        t.string :slug, null: false
        t.json :settings, null: false, default: {}
      end

      add_index :biovision_components, :slug, unique: true
    end

    unless Biovision::Parameter.table_exists?
      create_table :biovision_parameters do |t|
        t.timestamps
        t.references :biovision_components, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
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
    drop_table :biovision_parameters if Biovision::Parameter.table_exists?
    drop_table :biovision_components if Biovision::Component.table_exists?
  end

  private

  def seed_items
    component  = Biovision::Component.create!(slug: 'registration')
    collection = {
      open:          ['Регистрация открыта', '1', 'Разрешить регистрироваться новым пользователям'],
      invite_only:   ['Только по приглашению', '0', 'Регистрация только с кодом приглашения'],
      confirm_email: ['Подтверждать почту сразу', '0', 'Сразу после регистрации отправлять письмо для подтверждения почты']
    }
    create_parameters(component, collection)

    component  = Biovision::Component.create!(slug: 'contact')
    collection = {
      feedback_receiver: ['Адрес обратной связи', 'info@example.com', 'На этот адрес приходят запросы обратной связи'],
      email:             ['E-mail', 'info@example.com', 'Адрес электронной почты для отображения в контактах'],
      phone:             ['Телефон', '+7 (000) 000-00-00', 'Телефон для отображения в контактах'],
      address:           ['Адрес', 'г. Москва, улица с Названием, 42', 'Адрес для отображения в контактах']
    }
    create_parameters(component, collection)
  end

  # @param [Biovision::Component] component
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

      Biovision::Parameter.create!(attributes)
    end
  end
end
