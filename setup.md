Разворачивание нового приложения
================================

Для разворачивания проекта, создаем новый проект командой 
`rails new <имя проекта> --skip-spring` (если проект уже гитом скопировал 
из репозитория, то заходим в папку проекта и там вместо <имя проекта> будет 
точка)

Добавления в `.gitignore`
-------------------------

```
/public/uploads

/spec/examples.txt
/spec/support/uploads/*

.env
```

ПОСЛЕ добавления в `.gitignore`
-------------------------------

Далее, первым делом надо из папки sample в корне проекта biovision-base 
скопировать файлы в корень своего проекта (прямо поверх того, что там уже есть).

Не забудь отредактировать `.env`, девелопернейм!

Ещё нужно поменять `example.com` на актуальное название.

Также стоит удалить `app/assets/application.css`, так как используется scss,
и локаль `config/locales/en.yml`, если не планируется использование английской
локали.

Добавления в `Gemfile`
----------------------

```ruby
gem 'dotenv-rails'

gem 'autoprefixer-rails', group: :production

gem 'biovision-base', git: 'https://github.com/Biovision/biovision-base.git'
# gem 'biovision-base', path: '/Users/maxim/Projects/Biovision/gems/biovision-base'

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end
```

После запуска `bundle`
----------------------

```bash
yarn add @biovision/biovision
```

Нужно добавить в `app/assets/config/manifest.js`:

```js
//= link biovision_base_manifest
```

Изменения в `config/environments/production.rb`
-----------------------------------------------

Нужно раскомментировать строку `config.require_master_key = true` (на момент
написания это `19` строка).

Нужно выставить уровень сообщения об ошибках в `:warn` 
(`config.log_level = :warn` в районе `54` строки)

Изменения в `app/mailers/application_mailer.rb`
-----------------------------------------------

Нужно удалить строку с отправителем по умолчанию 
(`default from: 'from@example.com'`), иначе при отправке писем в бою будет
ошибка с неправильным отправителем, независимо от того, что написано
в конфигурации в `production.rb`.

Актуализация `config/database.yml`
----------------------------------

В файле `database.yml` нужно поменять названия баз данных на актуальные:

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

Добавления в `config/application.rb`
------------------------------------

Это добавляется в блок конфигурирования. Без этой настройки часовой пояс будет
задан как UTC.

```ruby
  config.time_zone = 'Moscow'
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
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  concern :removable_image do
    delete :image, action: :destroy_image, on: :member, defaults: { format: :json }
  end

  concern :lock do
    member do
      put :lock, defaults: { format: :json }
      delete :lock, action: :unlock, defaults: { format: :json }
    end
  end
  
  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'  
  end
```

Добавления в `config/application_controller.rb`
-----------------------------------------------

Добавить это в начале класса.

```ruby
  def default_url_options
    params.key?(:locale) ? { locale: I18n.locale } : {}
  end
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
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
```

Дополнения в `config/environments/development.rb`
-------------------------------------------------

```ruby
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_options = {
    from: 'example.com <webmaster@example.com>',
    reply_to: 'info@example.com'
  }
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
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
зашированный файл с ключом шифрования сессии (чтобы выйти из `vim` 
с сохранением, надо набрать `:wq`)

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

На серверной стороне нужно создать папку для пумы и файла с ключом шифрования: 
`mkdir -p /var/www/example.com/shared/tmp/puma`,
`mkdir -p /var/www/example.com/shared/config`.

После этого локально запустить `mina setup`. Для нормальной работы нужно 
не забыть скопировать на сервер `.env` и `config/master.key`.

`scp .env biovision:/var/www/example.com/shared`, 
`scp config/master.key biovision:/var/www/example.com/shared/config`

Важный момент для боевой версии касаемо `robots.txt`
----------------------------------------------------

В папке `sample/public` в файле `robots.txt` изначально стоит запрет индексации.
Это нужно на время разработки, чтобы поисковые роботы не полезли раньше времени
индексировать не готовый сайт.

Перед тем, как запускать боевую версию нужно не забыть поменять `Disallow: /`
на `Allow: /`.

Дополнительно на серверной стороне
----------------------------------

Можно добавить пуму в автозагрузку, чтобы она самостоятельно запускалась
при запуске системы. Есть два варианта:

### Автозагрузка в через `init.d`

Нужно добавить в джунгли строку для автоматического запуска пумы 
при перезагрузке сервера (`etc/puma.conf`), а также добавить конфигурацию
для ротации журнала по образцу существующих проектов (`etc/logrotate.d`).

### Автозагрузка через `systemd`

[Описание](https://github.com/puma/puma/blob/master/docs/systemd.md)

Нужно положить актуальную версию `example-com.service` из папки `sample/tmp`
в папку с проектом (поменять название и пути внутри). После этого из-под рута:

```bash
systemctl enable /var/www/example.com/example-com.service
systemctl daemon-reload
```

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

  client_max_body_size 32m;

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
