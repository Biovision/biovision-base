# frozen_string_literal: true

# Review personal notifications
class My::NotificationsController < ProfileController
  before_action :set_entity, only: %i[read destroy]

  # get /my/notifications
  def index
    respond_to do |format|
      format.html { @collection = Notification.page_for_owner(current_user, current_page) }
      format.json { @collection = Notification.unread.page_for_owner(current_user) }
    end
  end

  # get /my/notifications/count
  def count
    render json: { meta: { count: Notification.owned_by(current_user).unread.count } }
  end

  # put /my/notifications/:id/read
  def read
    @entity.update(read: true)

    head :no_content
  end

  # delete /my/notifications/:id
  def destroy
    @entity.destroy

    head :no_content
  end

  private

  def set_entity
    @entity = Notification.owned_by(current_user).find_by(params[:id])
    handle_http_404('Cannot find notification') if @entity.nil?
  end
end
