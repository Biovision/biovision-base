# frozen_string_literal: true

# Adds method for toggling entity flags
module ToggleableEntity
  extend ActiveSupport::Concern

  included do
    before_action :set_entity, only: :toggle
  end

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
    @entity.respond_to?(:locked?) ? @entity.locked? : false
  end
end
