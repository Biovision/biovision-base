'use strict';

let Biovision = {
    storage: {
        available: function (type) {
            try {
                const storage = window[type],
                    x = '__storage_test__';
                storage.setItem(x, x);
                storage.removeItem(x);
                return true;
            }
            catch (e) {
                return false;
            }
        },
        set: function (type, key, value) {
            if (Biovision.storage.available(type)) {
                window[type].setItem(key, value);
            } else {
                console.log('set: Storage ' + type + ' is not available');
            }
        },
        get: function (type, key) {
            if (Biovision.storage.available(type)) {
                return window[type].getItem(key);
            } else {
                console.log('get: Storage ' + type + ' is not available');
                return null;
            }
        },
        remove: function (type, key) {
            if (Biovision.storage.available(type)) {
                window[type].removeItem(key);
            } else {
                console.log('remove: Storage ' + type + ' is not available');
            }
        },
        session: {
            set: function (key, value) {
                Biovision.storage.set('sessionStorage', key, value);
            },
            get: function (key) {
                return Biovision.storage.get('sessionStorage', key);
            },
            remove: function (key) {
                Biovision.storage.remove('sessionStorage', key);
            }
        },
        local: {
            set: function (key, value) {
                Biovision.storage.set('localStorage', key, value);
            },
            get: function (key) {
                return Biovision.storage.get('localStorage', key);
            },
            remove: function (key) {
                Biovision.storage.remove('localStorage', key);
            }
        }
    },
    preview_file: function (input) {
        const target_image = input.getAttribute('data-image');

        if (target_image) {
            let target = document.querySelector('#' + target_image + ' img');

            if (target && input.files && input.files[0]) {
                let reader = new FileReader();

                reader.onload = function (event) {
                    target.setAttribute('src', event.target.result);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    }
};

document.addEventListener('DOMContentLoaded', function () {
    // Предварительный просмотр картинки при выборе файла
    document.addEventListener('change', function (event) {
        const input = event.target;

        if (input.matches('input[type=file]')) {
            Biovision.preview_file(input);
        }
    });

    $(document).on('click', 'div.toggleable > span', function () {
        if (!$(this).hasClass('switch')) {
            let $flag = $(this);
            let url = $(this).parent().data('url');
            let parameter = $(this).data('flag');

            $.post({
                url: url,
                data: {parameter: parameter},
                beforeSend: function () {
                    $flag.removeClass();
                    $flag.addClass('switch');
                },
                success: function (response) {
                    $flag.removeClass();
                    if (response.hasOwnProperty('data') && response['data'].hasOwnProperty(parameter)) {
                        switch (response['data'][parameter]) {
                            case true:
                                $flag.addClass('active');
                                break;
                            case false:
                                $flag.addClass('inactive');
                                break;
                            default:
                                $flag.addClass('unknown');
                        }
                    } else {
                        $flag.addClass('unknown');
                    }
                }
            }).fail(function (response) {
                $flag.removeClass();
                $flag.addClass('unknown');
                handle_ajax_failure(response);
            });
        }
    });

    $(document).on('click', 'li.lock > a', function () {
        let $container = $(this).closest('li');
        let $edit = $container.parent().find('.lockable');
        let url = $container.data('url');

        if (url.length > 1) {
            $.ajax(url, {
                method: $(this).hasClass('lock') ? 'put' : 'delete',
                success: function (response) {
                    if (response.hasOwnProperty('data') && response['data'].hasOwnProperty('locked')) {
                        let locked = response['data']['locked'];

                        locked ? $edit.addClass('hidden') : $edit.removeClass('hidden');

                        $container.find('a').each(function () {
                            if ($(this).hasClass('lock')) {
                                locked ? $(this).addClass('hidden') : $(this).removeClass('hidden');
                            } else {
                                locked ? $(this).removeClass('hidden') : $(this).addClass('hidden');
                            }
                        });
                    }
                }
            }).fail(handle_ajax_failure);
        }

        return false;
    });

    $(document).on('click', 'li.priority-changer > button', function () {
        let $li = $(this).closest('li[data-number]');
        let delta = parseInt(this.getAttribute('data-delta'));
        let url = $(this).parent().data('url');

        if (parseInt($li.data('number')) + delta > 0) {
            $.post(url, {delta: delta}, function (response) {
                console.log(response);
                if (response.hasOwnProperty('data')) {
                    let $container = $li.parent();
                    let $list = $container.children('li');

                    if (response['data'].hasOwnProperty('priority')) {
                        $li.data('number', response['data']['priority']);
                        $li.attr('data-number', response['data']['priority']);
                    } else {
                        for (let entity_id in response['data']) {
                            if (response['data'].hasOwnProperty(entity_id)) {
                                $li = $container.find('li[data-id=' + entity_id + ']');
                                $li.data('number', response['data'][entity_id]);
                                $li.attr('data-number', response['data'][entity_id]);
                            }
                        }
                    }
                    $list.sort(function (a, b) {
                        let an = parseInt($(a).data('number'));
                        let bn = parseInt($(b).data('number'));

                        if (an > bn) {
                            return 1;
                        } else if (an < bn) {
                            return -1;
                        } else {
                            return 0;
                        }
                    });

                    $list.detach().appendTo($container);
                }
            }).fail(handle_ajax_failure);
        }
    });

    $('div[data-destroy-url] button.destroy').on('click', function () {
        let $button = $(this);
        let $container = $(this).closest('div[data-destroy-url]');

        $button.attr('disabled', true);

        $.ajax($container.data('destroy-url'), {
            method: 'delete',
            success: function (response) {
                $container.remove();
            }
        }).fail(handle_ajax_failure);
    });

    $('.user-search button').on('click', function () {
        let $container = $(this).closest('.user-search');
        let $input = $container.find('input[type=search]');
        let $results = $container.find('.results');

        $.get($container.data('url'), {q: $input.val()}, function (response) {
            if (response.hasOwnProperty('data')) {
                $results.html(response['data']['html']);
            }
        }).fail(handle_ajax_failure);
    });

    $(document).on('click', '.user-search .results li', function () {
        let $container = $(this).closest('.user-search');
        let $target = $('#' + $container.data('target'));

        $target.val($(this).data('id'));
    });

    $.ajaxSetup({
        headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        }
    });
});

function handle_ajax_failure(response) {
    if (response.hasOwnProperty('responseJSON')) {
        console.log(response['responseJSON']);
    } else {
        console.log(response);
    }
}

/*
 *************
 * Polyfills *
 *************
 */

/**
 * Element.closest()
 *
 * IE 9+
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Element/closest
 */
if (!Element.prototype.matches) {
    Element.prototype.matches =
        Element.prototype.msMatchesSelector ||
        Element.prototype.webkitMatchesSelector;
}

if (!Element.prototype.closest) {
    Element.prototype.closest = function (s) {
        let el = this;
        let ancestor = this;

        if (!document.documentElement.contains(el)) {
            return null;
        }
        do {
            if (ancestor.matches(s)) {
                return ancestor;
            }
            ancestor = ancestor.parentElement;
        } while (ancestor !== null);

        return null;
    };
}

/**
 * Element.matches()
 *
 * IE 9+
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Element/matches
 */
if (!Element.prototype.matches) {
    Element.prototype.matches =
        Element.prototype.msMatchesSelector ||
        Element.prototype.webkitMatchesSelector;
}
