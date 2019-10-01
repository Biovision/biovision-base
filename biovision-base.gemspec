$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "biovision/base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "biovision-base"
  s.version     = Biovision::Base::VERSION
  s.authors     = ["Maxim Khan-Magomedov"]
  s.email       = ["maxim.km@gmail.com"]
  s.homepage    = "https://github.com/Biovision/biovision-base"
  s.summary     = "Base components for Biovision applications"
  s.description = "Base components for Biovision applications. Models, Controllers, locales, some JS and SCSS"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '~> 5.2'
  s.add_dependency 'rails-i18n', '~> 5.0'

  s.add_dependency 'bcrypt', '~> 3.1'
  s.add_dependency 'carrierwave', '~> 1.2'
  s.add_dependency 'carrierwave-bombshelter', '~> 0.2'
  s.add_dependency 'kaminari', '~> 1.1'
  s.add_dependency 'mini_magick', '~> 4.9', '>= 4.9.5'
  s.add_dependency 'rest-client', '~> 2.1'

  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
end
