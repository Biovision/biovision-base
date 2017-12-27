config.time_zone = 'Moscow'

config.i18n.enforce_available_locales = true
config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
config.i18n.default_locale = :ru

%w(app/services lib).each do |path|
  config.autoload_paths << config.root.join(path).to_s
end

config.exceptions_app = self.routes
