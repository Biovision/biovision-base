module ToggleableEntity
  extend ActiveSupport::Concern

  # Toggle entity flag when allowed
  def toggle
    if entity_is_locked?
      render json: { errors: { locked: true } }, status: :forbidden
    elsif entity_is_editable?
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    else
      head :unauthorized
    end
  end

  private

  def entity_is_editable?
    if @entity.respond_to?(:editable_by?)
      @entity.editable_by?(current_user)
    else
      true
    end
  end

  def entity_is_locked?
    if @entity.respond_to?(:locked?)
      @entity.locked?
    else
      false
    end
  end
end
