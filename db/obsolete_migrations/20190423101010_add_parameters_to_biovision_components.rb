# frozen_string_literal: true

# Convert BiovisionParameter records to JSONB data in BiovisionComponent
class AddParametersToBiovisionComponents < ActiveRecord::Migration[5.2]
  def up
    return if column_exists?(:biovision_components, :parameters)

    add_column :biovision_components, :parameters, :jsonb, default: {}, null: false

    move_data
  end

  def down
    # No rollback needed
  end

  private

  def move_data
    BiovisionComponent.order('id asc').each do |component|
      data = {}
      BiovisionParameter.where(biovision_component: component).each do |parameter|
        data[parameter.slug] = parameter.value
      end

      component.update! parameters: data
    end
  end
end
