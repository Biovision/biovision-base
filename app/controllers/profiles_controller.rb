class ProfilesController < ApplicationController
  before_action :set_entity

  # get /u/:slug
  def show
  end

  # get /u/:slug/followees
  def followees
    @filter     = params[:filter] || Hash.new
    @collection = UserLink.filtered(:followee, @filter).with_follower(@entity).page_for_user(current_page)
  end

  private

  def component_slug
    Biovision::Components::UsersComponent::SLUG
  end

  def set_entity
    @entity = User.find_by(slug: params[:slug].downcase, deleted: false)
    if @entity.nil?
      handle_http_404('Cannot find user')
    end
  end
end
