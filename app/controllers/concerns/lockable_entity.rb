# frozen_string_literal: true

# Adds methods for locking and unlocking entity
module LockableEntity
  extend ActiveSupport::Concern

  included do
    before_action :set_entity, only: %i[lock unlock]
  end

  def lock
    @entity.update!(locked: true)

    render json: { data: { locked: @entity.locked? } }
  end

  def unlock
    @entity.update!(locked: false)

    render json: { data: { locked: @entity.locked? } }
  end

  protected

  def check_entity_lock
    return unless @entity.locked?

    render json: { errors: { locked: @entity.locked? } }, status: :forbidden
  end
end
