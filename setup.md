Разворачивание нового приложения
================================

Для разворачивания проекта, создаем новый проект командой `rails new <имя проекта> --skip-spring`
(если проект уже гитом скопировал из репозитория, то заходим в папку проекта и там вместо <имя проекта> будет точка)

Добавления в `.gitignore`
-------------------------

```
/public/uploads

/spec/examples.txt
/spec/support/uploads/*

.env
```

ПОСЛЕ добавления в `.gitignore`
-------------------------

Далее, первым делом надо из папки sample в корне проекта biovision-base скопировать файлы в корень своего проекта (прямо поверх того, что там уже есть).

Не забудь отредактировать `.env`, девелопернейм!

Ещё нужно поменять `example.com` на актуальное название.

Также стоит удалить `app/assets/application.css`, так как используется scss,
и локаль `config/locales/en.yml`, если не планируется использование английской
локали.



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

Заменить `sass-rails` на `sassc-rails` без версии (на момент написания доки на уровне 13 строки)

Добавления в `app/assets/application.js`
----------------------------------------

Это добавляется перед `//= require tree .`

```js
//= require biovision/base/biovision
//= require biovision/base/biovision-sliders
```

Если нужна поддержка jQuery, то добавить ещё и это, не забыв раскомментировать
`gem 'jquery-rails'` в `Gemfile`:

```js
//= require jquery3
```

Изменения в `config/environments/production.rb`
-----------------------------------------------

Нужно раскомментировать строку `config.require_master_key = true` (на момент
написания это `19` строка).

Если при развёртывании не компилируется JS, нужно заменить строку
`config.assets.js_compressor = :uglifier` на 
`config.assets.js_compressor = Uglifier.new(harmony: true)` 
(в районе `26` строки).

Нужно выставить уровень сообщения об ошибках в `:warn` 
(`config.log_level = :warn` в районе `54` строки)

Актуализация `config/database.yml`
----------------------------------

В файле database.yml нужно поменять названия баз данных на актуальные:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

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
Rails.application.config.assets.precompile << %w[admin.scss biovision/base/**/*]
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

```ruby
  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'  
  end
```

Добавления в `config/application_controller.rb`
-----------------------------------------------

Если не используются регионы, добавить это перед в начале класса.

```ruby
  include Biovision::Base::PrivilegeMethods

  def default_url_options
    params.key?(:locale) ? { locale: I18n.locale } : {}
  end
```

Если регионы используются, добавить вместо этого строку из модуля регионов.

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

Вариант для `yandex.ru`

```ruby
  config.action_mailer.smtp_settings = {
    address: 'smtp.yandex.ru',
    port: 465,
    tls: true,
    domain: 'example.com',
    user_name: 'webmaster@example.com',
    password: ENV['MAIL_PASSWORD'],
    authentication: :plain,
    enable_starttls_auto: true
  }
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'info@example.com'
  }
  config.action_mailer.default_url_options = { host: 'example.com' }
```

Дополнения в `config/environments/test.rb`
------------------------------------------

```ruby
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'info@example.com'
  }
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
```

Дополнения в `config/environments/development.rb`
-------------------------------------------------

```ruby
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_options = {
      from: 'example.com <webmaster@example.com>',
      reply_to: 'info@example.com'
  }
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
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

После установки приложения нужно накатить миграции (в консоли):

 1. `rails db:create`
 2. `rails railties:install:migrations`
 3. `rails db:migrate`

Для удобства запуска на сервере:

```bash
bundle binstubs bundler --force
bundle binstub puma
```

Также имеет смысл запустить `EDITOR=vim rails credentials:edit`, чтобы создать
зашированный файл с ключом шифрования сессии. (чтобы выйти из `vim` с сохранением надо набрать `:wq`)

Не забыть скопировать `.env` и `config/master.key` на сервер:
`scp .env biovision:/var/www/example.com/shared`, 
`scp config/master.key biovision:/var/www/example.com/shared/config`,

Настройка отгрузки через `mina`
-------------------------------

Для начала надо запустить в консоли `mina init`. После этого внести изменения
в `config/deploy.rb`.

В начале и середине файла раскомментировать то, что относится к `rbenv`.

Для `shared_dirs` и `shared_files` задать примерно такой вид.

```ruby
set :shared_dirs, fetch(:shared_dirs, []).push('public/uploads', 'tmp', 'log')
set :shared_files, fetch(:shared_files, []).push('config/master.key', '.env')
```

На серверной стороне нужно создать папку для пумы: 
`mkdir -p /var/www/example.com/shared/tmp/puma`

После этого локально запустить `mina setup`. Для нормальной работы нужно 
не забыть скопировать на сервер `.env` и `config/master.key`.

Дополнительно на серверной стороне
----------------------------------

Нужно добавить в джунгли строку для автоматического запуска пумы 
при перезагрузке сервера (`etc/puma.conf`), а также добавить конфигурацию
для ротации журнала по образцу существующих проектов (`etc/logrotate.d`).

Пример конфигурации nginx
-------------------------

```nginx
upstream example.com {
  server unix:///var/www/example.com/shared/tmp/puma.sock;
}

# Перенаправление версий с www и без www с http на https
#server {
#  listen 80;
#  server_name example.com www.example.com;
#
#  return 301 https://example.com$request_uri;
#}

# Перенаправление версий https с www на версию без www
#server {
#  listen 443 ssl http2;
#  listen [::]:443 ssl http2;
#  server_name www.example.com;
#
#  ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
#  ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
#  include snippets/ssl-params.conf;
#
#  return 301 https://example.com$request_uri;
#}

server {
  listen 80;
#  listen 443 ssl http2;
#  listen [::]:443 ssl http2;

#  ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
#  ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
#  include snippets/ssl-params.conf;

  server_name example.com www.example.com;
  root /var/www/example.com/current/public;
  access_log /var/log/nginx/example.com-access.log combined;
  error_log /var/log/nginx/example.com-error.log notice;

  gzip on;
  gzip_types text/plain text/css application/json application/javascript image/svg+xml text/xml application/xml application/xml+rss;

  location ~* ^.+\.(css|js|jpe?g|svg|txt|gif|png|ico)$ {
    access_log off;
    expires 7d;
  }

  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Host $host;

    if (!-f $request_filename) {
      proxy_pass http://example.com;
      break;
    }
  }

# Раскомментировать, если используется actioncable
#  location /cable {
#    proxy_pass http://example.com;
#    proxy_http_version 1.1;
#    proxy_set_header Upgrade $http_upgrade;
#    proxy_set_header Connection "upgrade";
#  }
}
```

Фрагмент для пумы
-----------------

```conf
/var/www/example.com/current,developer,/var/www/example.com/current/config/puma.rb,/var/www/example.com/shared/log/puma.log,RAILS_ENV=production
```

Logrotate для нового проекта
----------------------------

```
/var/www/example.com/shared/log/*.log {
   su developer developer
   daily
   missingok
   rotate 7
   compress
   delaycompress
   notifempty
   copytruncate
}
```
