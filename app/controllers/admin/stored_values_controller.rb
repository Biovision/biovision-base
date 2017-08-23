class Admin::StoredValuesController < AdminController
  before_action :set_entity, except: [:index]

  # get /admin/stored_values
  def index
    @collection = StoredValue.page_for_administration
  end

  # get /admin/stored_values/:id
  def show
  end

  protected

  def restrict_access
    require_privilege :administrator
  end

  def set_entity
    @entity = StoredValue.find_by(id: params[:id])
    if @entity.nil?
      handle_http_404('Cannot find stored_value')
    end
  end
end
