class Admin::MetricsController < AdminController
  before_action :set_entity, except: [:index]

  # get /admin/metrics
  def index
    @collection = Metric.page_for_administration
  end

  # get /admin/metrics/:id
  def show
  end

  protected

  def restrict_access
    require_privilege :metrics_manager
  end

  def set_entity
    @entity = Metric.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find metric')
    end
  end
end
