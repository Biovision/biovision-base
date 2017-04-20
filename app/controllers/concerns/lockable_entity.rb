module LockableEntity
  extend ActiveSupport::Concern

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
    if @entity.locked?
      render json: { errors: { locked: @entity.locked } }, status: :forbidden
    end
  end
end
