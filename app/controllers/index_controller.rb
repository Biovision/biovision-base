class IndexController < ApplicationController
  # get /
  def index
    @editable_page = EditablePage.find_by(slug: 'index')
  end
end
