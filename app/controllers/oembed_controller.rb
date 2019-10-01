# frozen_string_literal: true

# Receiving oembed data by URLs
class OembedController < ApplicationController
  # get /oembed?url=
  def code
    receiver = OembedReceiver.new(param_from_request(:url))

    render json: { meta: { code: receiver.code } }
  end
end
