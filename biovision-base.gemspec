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
  s.description = "Base components for Biovision applications. Locales, some JS and SCSS"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"
  s.add_dependency 'rails-i18n', '~> 5.0.0'
  s.add_dependency 'kaminari'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
end
