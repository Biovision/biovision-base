module Biovision
  module Base
    class Engine < ::Rails::Engine
      initializer  "biovision_base.load_base_methods" do
        ActiveSupport.on_load(:action_controller) do
          include Biovision::Base::BaseMethods
        end
      end
    end

    require 'kaminari'
    require 'rails_i18n'
  end
end
