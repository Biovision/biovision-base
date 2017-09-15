class AboutController < ApplicationController
  # get /about
  def index
    @editable_page = EditablePage.find_by(slug: 'about')

    render :editable
  end

  # get /tos
  def tos
    @editable_page = EditablePage.find_by(slug: 'tos')

    render :editable
  end
end
