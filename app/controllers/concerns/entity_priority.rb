module EntityPriority
  extend ActiveSupport::Concern

  def priority
    render json: { data: @entity.change_priority(params[:delta].to_s.to_i) }
  end
end
