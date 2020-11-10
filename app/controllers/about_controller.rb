class AboutController < ApplicationController
  # get /about
  def index
    @editable_page = EditablePage['about']

    render :editable
  end

  # get /tos
  def tos
    @editable_page = EditablePage['tos']

    render :editable
  end

  # get /privacy
  def privacy
    @editable_page = EditablePage['privacy']

    render :editable
  end

  # get /contact
  def contact
    @editable_page = EditablePage['contact']
  end
end
