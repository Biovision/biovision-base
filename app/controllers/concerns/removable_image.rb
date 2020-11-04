# frozen_string_literal: true

# Adds action for removing entity image in column "image"
module RemovableImage
  extend ActiveSupport::Concern

  # Remove entity image when allowed
  def destroy_image
    if entity_image_is_locked?
      render json: { errors: { locked: true } }, status: :forbidden
    elsif entity_image_is_editable?
      @entity.remove_image!
      render json: { meta: { result: @entity.save } }
    else
      head :unauthorized
    end
  end

  private

  def entity_image_is_editable?
    if @entity.respond_to?(:editable_by?)
      @entity.editable_by?(current_user)
    else
      true
    end
  end

  def entity_image_is_locked?
    @entity.respond_to?(:locked?) ? @entity.locked? : false
  end
end
