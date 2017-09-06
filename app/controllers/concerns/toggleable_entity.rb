module ToggleableEntity
  extend ActiveSupport::Concern

  # Toggle entity flag when allowed
  def toggle
    if allow_toggle?
      render json: { data: @entity.toggle_parameter(params[:parameter].to_s) }
    else
      head :unauthorized
    end
  end

  private

  # If entity responds to #editable_by?, it should be editable to be toggled
  def allow_toggle?
    if @entity.respond_to?(:editable_by?)
      @entity.editable_by?(current_user)
    else
      true
    end
  end
end
