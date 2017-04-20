module ToggleableEntity
  extend ActiveSupport::Concern

  def toggle
    render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
  end

  protected

  def check_entity_lock
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    end
  end
end
