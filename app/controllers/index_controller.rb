class IndexController < ApplicationController
  # get /
  def index
    @editable_page = EditablePage.localized_page('index', locale)
    check_referral_link if params.key?(:rl)
  end

  private

  def check_referral_link
    return if cookies['r']
    cookies['r'] = {
      value: param_from_request(:rl),
      expires: 1.year.from_now,
      domain: :all,
      httponly: true
    }
  end
end
