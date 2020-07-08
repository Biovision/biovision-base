# frozen_string_literal: true

module Biovision
  # Biovision base
  module Base
    # Engine class for Biovision base
    class Engine < ::Rails::Engine
      initializer 'biovision_base.load_base_methods' do
        ActiveSupport.on_load(:action_controller) do
          include Biovision::Base::BaseMethods
        end
      end

      # config.assets.precompile << %w[biovision_base_manifest.js]

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot, dir: 'spec/factories'
      end
    end

    require 'kaminari'
    require 'rails_i18n'
    require 'carrierwave'
    require 'mini_magick'
    require 'carrierwave-bombshelter'
    require 'rest-client'
  end
end
