class MetricsController < AdminController
  before_action :set_entity, only: [:edit, :update]

  # get /metrics/:id/edit
  def edit
  end

  # patch /metrics/:id
  def update
    if @entity.update entity_parameters
      redirect_to admin_metric_path(id: @entity.id), notice: t('metrics.update.success')
    else
      render :edit, status: :bad_request
    end
  end

  private

  def restrict_access
    require_privilege :metrics_manager
  end

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
