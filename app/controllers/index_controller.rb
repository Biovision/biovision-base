class IndexController < ApplicationController
  # get /
  def index
    @editable_page = EditablePage.find_localized('index', locale)
  end
end
