class FallbackController < ApplicationController
  # get (:editable_page_url)
  def show
    url = params[:editable_page_url]

    @editable_page = EditablePage.fallback_page("/#{url}", locale)
    if @editable_page.nil?
      handle_http_404("Cannot find fallback page for url /#{url}")
    end
  end
end
