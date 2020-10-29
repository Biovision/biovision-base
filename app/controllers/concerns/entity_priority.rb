# frozen_string_literal: true

# Adds method for changing entity priority
module EntityPriority
  extend ActiveSupport::Concern

  included do
    before_action :set_entity, only: :priority
  end

  def priority
    render json: { data: @entity.change_priority(params[:delta].to_s.to_i) }
  end
end
