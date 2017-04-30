module ToggleableEntity
  extend ActiveSupport::Concern

  def toggle
    render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
  end
end
