Biovision::Base
===============

Базовый функционал: пользователи, метрики, привилегии, редактируемые страницы.

Используйте на свой страх и риск без каких-либо гарантий работоспособности.

Описание необходимых и рекомендуемых действий находится в `setup.md`

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
