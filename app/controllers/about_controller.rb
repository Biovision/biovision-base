class AboutController < ApplicationController
  # get /about
  def index
    @editable_page = EditablePage.find_localized('about', locale)

    render :editable
  end

  # get /tos
  def tos
    @editable_page = EditablePage.find_localized('tos', locale)

    render :editable
  end

  # get /privacy
  def privacy
    @editable_page = EditablePage.find_localized('privacy', locale)

    render :editable
  end

  # get /contact
  def contact
    @editable_page = EditablePage.find_localized('contact', locale)
  end
end
