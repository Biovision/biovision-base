overrides = "#{Rails.root}/app/overrides"
Rails.autoloaders.main.ignore(overrides)
Rails.application.configure do
  config.to_prepare do
    Dir.glob("#{overrides}/**/*_override.rb").each do |override|
      load override
    end
  end
end
