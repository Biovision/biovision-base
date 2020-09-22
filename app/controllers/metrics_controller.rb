class MetricsController < AdminController
  before_action :set_entity, only: [:edit, :update]

  # get /metrics/:id/edit
  def edit
  end

  # patch /metrics/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_metric_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  private

  def set_entity
    @entity = Metric.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find metric')
    end
  end

  def entity_parameters
    params.require(:metric).permit(Metric.entity_parameters)
  end
end
