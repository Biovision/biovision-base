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

Использование листалок
----------------------

Если контейнеру задать класс `biovision-slider` и добавить в него кнопки
с классами `prev` и `next`, а также список (`ul`), то при условии, что подгружен
файл `biovision/base/biovision-sliders.js`, к этому контейнеру применится
поведение листалки.

Параметры, которые можно задать через data-атрибуты:

 * `delay` — задержка перед пролистыванием. По умолчанию — `125` (мс)
 * `type` — тип. По умолчанию — `opacity` (пока это единственный вариант)

```html
<div class="biovision-slider" data-delay="250" data-type="opacity">
    <button class="prev"></button>
    <ul>
        <li>Slide 1</li>
        <li>Slide 2</li>
        <li>Slide 3</li>
    </ul>
    <button class="next"></button>
</div>
```

```scss
.biovision-slider {
  display: flex;
    
  button {
    background: lime;
    flex: none;
    width: 2rem;
  }
    
  ul {
    display: flex;
    flex: 1;
    overflow: hidden;
  }
    
  li {
    flex: none;
    transition: .125s;
    width: 20rem;
  }
}
```

Проверка данных до отправки всей формы
--------------------------------------

Например, при регистрации нового пользователя нужно проверить, что почта или
логин не заняты. Для этого нужно сделать несколько шагов.

1. Маршрут и ответная часть в контроллере, обрабатывающая post-запрос.
   В ответе должен быть JSON с параметром `meta.valid` (boolean) и `meta.errors`
   (array), где ключ для `meta.errors` — это поле, а значение — текст ошибки.

2. Для формы нужно задать атрибут `data-check-url` с указанием на URL проверки
   правильности ввода.
   
3. Для элементов формы нужно задать атибут `data-check` со значением ключа,
   который проверяется.
   
4. Рядом с элементом нужно добавить `div` с атрибутом `data-field` и таким же
   значением, а также классом `check-result-error hidden`.
   
Пример — [app/views/my/profiles/new/_form.html.erb](https://github.com/Biovision/biovision-base/blob/master/app/views/my/profiles/new/_form.html.erb),
[app/controllers/users_controller.rb#check](https://github.com/Biovision/biovision-base/blob/master/app/controllers/users_controller.rb#L8),
[app/views/users/check.jbuilder](https://github.com/Biovision/biovision-base/blob/master/app/views/users/check.jbuilder)

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
