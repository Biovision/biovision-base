Разворачивание нового приложения
================================

Не забудь отредактировать `.env`, девелопернейм!

Ещё нужно поменять `example.com` на актуальное название.

Также стоит удалить `app/assets/application.css`, так как используется scss,
и локаль `config/locales/en.yml`, если не планируется использование английской
локали.

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
# gem 'jquery-rails' # Раскомментировать, если нужна поддержка jQuery

gem 'autoprefixer-rails', group: :production

gem 'biovision-base', git: 'https://github.com/Biovision/biovision-base.git'
# gem 'biovision-base', path: '/Users/maxim/Projects/Biovision/gems/biovision-base'

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'mina'
end
```

Добавления в `app/assets/application.js`
----------------------------------------

Это добавляется перед `//= require tree .`

```js
//= require biovision/base/biovision.js
```

Если нужна поддержка jQuery, то добавить ещё и это, не забыв раскомментировать
`gem 'jquery-rails'` в `Gemfile`:

```js
//= require jquery3
```

Изменения в `config/environments/production.rb`
-----------------------------------------------

Если при развёртывании не компилируется JS, нужно заменить строку
`config.assets.js_compressor = :uglifier` на 
`config.assets.js_compressor = Uglifier.new(harmony: true)` 
(в районе `27` строки).

Нужно выставить уровень сообщения об ошибках в `:warn` 
(`config.log_level = :warn` в районе `52` строки)

Добавления в `config/application.rb`
------------------------------------

Инициализация локали и разруливания ошибок через `ErrorsController` находится
в `config/initializers/biovision.rb`.

```ruby
  class Application < Rails::Application
    %w(app/services lib).each do |path|
      config.autoload_paths << config.root.join(path).to_s
    end
  end
```

Актуализация `config/database.yml`
----------------------------------

В файле database.yml нужно поменять названия баз данных на актуальные:

```yaml
development:
  <<: *default
  database: example # Поменять на актуальное название
  
test:
  <<: *default
  database: example_test # Такое же, как в development, но с приставкой _test

production:
  <<: *default
  database: example # Такое же, как в development, например
  username: example # Поменять на актуального пользователя
  password: <%= ENV['DATABASE_PASSWORD'] %>
  host: localhost  
```

Добавления в `config/initializers/assets.rb`
--------------------------------------------

```ruby
Rails.application.config.assets.precompile << %w(admin.scss)
Rails.application.config.assets.precompile << %w(biovision/base/**/*)
```

Добавления в `spec/rails_helper.rb` (`$ rails generate rspec:install`)
----------------------------------------------------------------------

Раскомментировать строку 23 (включение содержимого `spec/support`)

```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

Добавления в `spec/spec_helper.rb`
----------------------------------

```ruby
RSpec.configure do |config|
  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end
end
```

Добавления в `config/routes.rb`
-------------------------------

По желанию:

```ruby
  concern :toggleable do
    post 'toggle', on: :member
  end

  concern :lockable do
    member do
      put 'lock'
      delete 'lock', action: :unlock
    end
  end

  concern :changeable_priority do
    post 'priority', on: :member
  end
```

Обязательно:

```ruby
  root 'index#index'
  
  mount Biovision::Base::Engine, at: '/'
```

Дополнения в `config/environments/production.rb`
------------------------------------------------

Вариант для `mail.ru`

```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: 'smtp.mail.ru',
      port: 465,
      tls: true,
      domain: 'example.com',
      user_name: 'webmaster@example.com',
      password: ENV['MAIL_PASSWORD'],
      authentication: :login,
      enable_starttls_auto: true
  }
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { host: 'example.com' }
```

Вариант для `gmail.com`

```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'example.com',
      user_name: 'webmaster@example.com',
      password: ENV['MAIL_PASSWORD'],
      authentication: :plain,
      enable_starttls_auto: true
  }
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { host: 'example.com' }
```

Дополнения в `config/environments/test.rb`
------------------------------------------

```ruby
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { :host => '0.0.0.0:3000' }
```

Дополнения в `config/environments/development.rb`
-------------------------------------------------

```ruby
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'support@example.com'
  }
  config.action_mailer.default_url_options = { :host => '0.0.0.0:3000' }
```

Дополнения в `config/puma.rb`
-----------------------------

Нужно обязательно закомментировать строку с портом, так как используется сокет.
На момент написания документации это 12 строка:
`port        ENV.fetch("PORT") { 3000 }`

```ruby
if ENV['RAILS_ENV'] == 'production'
  shared_path = '/var/www/example.com/shared'
  logs_dir    = "#{shared_path}/log"

  state_path "#{shared_path}/tmp/puma/state"
  pidfile "#{shared_path}/tmp/puma/pid"
  bind "unix://#{shared_path}/tmp/puma.sock"
  stdout_redirect "#{logs_dir}/stdout.log", "#{logs_dir}/stderr.log", true
  
  activate_control_app
end
```

Перед запуском:
---------------

После установки приложения нужно накатить миграции:

 1. `$ rails railties:install:migrations`
 2. `$ rails db:migrate`

Для удобства запуска на сервере:

`$ bundle binstub puma`
