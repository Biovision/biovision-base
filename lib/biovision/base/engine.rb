module Biovision
  module Base
    class Engine < ::Rails::Engine
      initializer  "biovision_base.load_base_methods" do
        ActiveSupport.on_load(:action_controller) do
          include Biovision::Base::BaseMethods
        end
      end

      config.to_prepare do
        Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
          require_dependency(c)
        end
      end
    end

    require 'kaminari'
    require 'rails_i18n'
    require 'carrierwave'
    require 'mini_magick'
    require 'carrierwave-bombshelter'
  end
end
