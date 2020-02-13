# frozen_string_literal

# Review and send messages to other users
class My::MessagesController < ProfileController
  before_action :set_other_user, only: %i[user create]

  # get /my/messages
  def index
    @collection = component_handler.interlocutors
    @count = UserMessage.received_by(current_user).unread.count
  end

  # get /my/messages/:slug
  def user
    respond_to do |format|
      format.html
      format.json do
        @collection = component_handler.messages(@other_user, current_page)
        UserMessage.sent_by(@other_user).received_by(current_user).update_all(read: true)
        render
      end
    end
  end

  # post /my/messages/:slug
  def create
    @entity = UserMessage.new(creation_parameters)
    if @entity.save
      notifier = Biovision::Notifiers::SocializationNotifier.new(@entity.receiver)
      notifier.new_message(@entity.sender_id)
      render 'show'
    else
      render 'shared/forms/check'
    end
  end

  private

  def set_other_user
    @other_user = User.find_by(slug: params[:slug].downcase, deleted: false)
    handle_http_404('Cannot find other user') if @other_user.nil?
  end

  def component_class
    Biovision::Components::SocializationComponent
  end

  def creation_parameters
    permitted = UserMessage.entity_parameters
    parameters = params.require(:user_message).permit(permitted)
    parameters[:sender_id] = current_user.id
    parameters[:receiver_id] = @other_user.id
    parameters.merge(tracking_for_entity)
  end
end
