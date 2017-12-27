Rails.application.configure do
  config.time_zone = 'Moscow'

  config.i18n.enforce_available_locales = true
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  config.i18n.default_locale = :ru
  
  config.exceptions_app = self.routes
end
