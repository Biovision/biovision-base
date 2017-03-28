Biovision::Base
===============

Базовый функционал: пользователи, метрики, браузеры, АП, привилегии.

Используйте на свой страх и риск без каких-либо гарантий работоспособности.

ToDo
-----

 * Тесты для запирания/отпирания в контроллерах
 * Тесты для смены порядки сортировки в контроллерах
 * Подгрузка метрик через AJAX
 * Несколько метрик в одном графике
 * Настройка цветов в графиках
 * Анализ журнала доступа nginx
 * Работа с подсетями (чёрные списки IP и так далее)

Добавления в `.gitignore`
-------------------------

```
/public/uploads

/spec/examples.txt
/spec/support/uploads/*

.env
```

Добавления в `Gemfile`
----------------------

```ruby
gem 'dotenv-rails'

gem 'autoprefixer-rails', group: :production

gem 'biovision-base', git: 'https://github.com/Biovision/biovision-base.git'

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

group :development do
  gem 'mina'
end
```

Добавления в `app/assets/javascripts/application.js`
----------------------------------------------------

Это добавляется перед `//= require tree .`

```js
//= require biovision/base/biovision.js
```

Добавления в `config/application.rb`
------------------------------------


```ruby
  class Application < Rails::Application
    config.time_zone = 'Moscow'

    config.i18n.enforce_available_locales = true
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ru

    %w(app/services lib).each do |path|
      config.autoload_paths << config.root.join(path).to_s
    end

    config.assets.precompile << %w(biovision/base/icons/*)
    config.assets.precompile << %w(biovision/base/placeholders/*)
  end
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'biovision-base'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install biovision-base
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
