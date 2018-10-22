# frozen_string_literal: true

# Fallback controller for the rest of URLs
#
# Tries to find and show editable page with given url
class FallbackController < ApplicationController
  # get (:slug)
  def show
    url = params[:slug]

    @editable_page = EditablePage.fallback_page("/#{url}", locale)
    if @editable_page.nil?
      handle_http_404("Cannot find fallback page for url /#{url}")
    end
  end
end
