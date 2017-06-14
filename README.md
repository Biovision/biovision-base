Biovision::Base
===============

Базовый функционал: пользователи, метрики, браузеры, АП, привилегии.

Используйте на свой страх и риск без каких-либо гарантий работоспособности.

ToDo
-----

 * Тесты для запирания/отпирания в контроллерах
 * Тесты для смены порядка сортировки в контроллерах
 * Подгрузка метрик через AJAX
 * Несколько метрик в одном графике
 * Настройка цветов в графиках
 * Анализ журнала доступа nginx
 * Работа с подсетями (чёрные списки IP и так далее)

Описание необходимых и рекомендуемых действий находится в `biovision/snippets`

Очистка устаревших сессий
-------------------------

Чтобы устаревшие жетоны пользователей очищались, нужно добавить задачу 
`tokens:clean` в крон. Например (заменить `example.com` на актуальный домен):

```
0 4 * * * cd /var/www/example.com/current && /home/developer/.rbenv/shims/bundle exec rake RAILS_ENV=production tokens:clean
```

Каждый день в 4 часа ночи будут очищаться старые жетоны.

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
