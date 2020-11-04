# frozen_string_literal: true

# Adds method for creating, editing and destroying entities
module ListAndShowEntities
  extend ActiveSupport::Concern

  # Define in controllers
  def model_class
    @model_class ||= controller_name.classify.constantize
  end

  # Define in controllers
  def paginate_entities?
    model_class.respond_to?(:page_for_administration)
  end

  # get /admin/[table_name]
  def index
    @collection = if paginate_entities?
                    model_class.page_for_administration(current_page)
                  else
                    model_class.list_for_administration
                  end
  end

  # get /admin/[table_name]/:id
  def show
  end

  def set_entity
    @entity = model_class.find_by(id: params[:id])
    handle_http_404("Cannot find #{model_class.model_name}") if @entity.nil?
  end
end
