# frozen_string_literal: true

# Public user interaction
class ProfilesController < ApplicationController
  before_action :restrict_anonymous_access, except: %i[show followers followees]
  before_action :set_socialization, only: %i[ban follow unban unfollow]
  before_action :set_entity

  # get /u/:slug
  def show
  end

  # get /u/:slug/followees
  def followees
    @filter     = params[:filter] || Hash.new
    @collection = UserLink.filtered(:followee, @filter).with_follower(@entity).page_for_user(current_page)
  end

  # put /u/:slug/follow
  def follow
    @socialization.follow(@entity)

    head :no_content
  end

  # delete /u/:slug/follow
  def unfollow
    @socialization.unfollow(@entity)

    head :no_content
  end

  # put /u/:slug/ban
  def ban
    @socialization.ban(@entity)

    head :no_content
  end

  # delete /u/:slug/ban
  def unban
    @socialization.unban(@entity)

    head :no_content
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end

  def set_socialization
    @socialization = Biovision::Components::SocializationComponent[current_user]
  end

  def set_entity
    @entity = User.find_by(slug: params[:slug].downcase, deleted: false)
    handle_http_404('Cannot find user') if @entity.nil?
  end
end
