class AboutController < ApplicationController
  # get /about
  def index
    @editable_page = EditablePage.localized_page('about', locale)

    render :editable
  end

  # get /tos
  def tos
    @editable_page = EditablePage.localized_page('tos', locale)

    render :editable
  end

  # get /privacy
  def privacy
    @editable_page = EditablePage.localized_page('privacy', locale)

    render :editable
  end

  # get /contact
  def contact
    @editable_page = EditablePage.localized_page('contact', locale)
  end
end
