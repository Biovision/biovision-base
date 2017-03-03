class Admin::MetricsController < ApplicationController
  before_action :restrict_access
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
    require_role :administrator
  end

  def set_entity
    @entity = Metric.find params[:id]
  end
end
