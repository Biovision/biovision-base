'use strict';

const Biovision = {
    storage: {
        available: function (type) {
            try {
                const x = '__storage_test__';

                window[type].setItem(x, x);
                window[type].removeItem(x);

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
            const target = document.querySelector('#' + target_image + ' img');

            if (target && input.files && input.files[0]) {
                const reader = new FileReader();

                reader.onload = function (event) {
                    target.setAttribute('src', event.target.result);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    },
    new_ajax_request: function (method, url, on_success, on_failure) {
        const request = new XMLHttpRequest();

        request.addEventListener('load', function () {
            if (this.status >= 200 && this.status < 400) {
                if (on_success) {
                    on_success.call(this);
                }
            } else {
                (on_failure || Biovision.handle_ajax_failure).call(this);
            }
        });
        request.addEventListener('error', function () {
            console.log(this);
        });

        request.open(method.toUpperCase(), url);
        request.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        request.setRequestHeader('X-CSRF-Token', Biovision.csrf_token);

        return request;
    },
    handle_ajax_failure: function (response) {
        console.log(this);
        if (response.hasOwnProperty('responseJSON')) {
            console.log(response['responseJSON']);
        } else {
            console.log(response);
        }
    },
    transliterate: function(input) {
        const char_map = {
            'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd',
            'е': 'e', 'ё': 'yo', 'ж': 'zh', 'з': 'z', 'и': 'i',
            'й': 'j', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n',
            'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't',
            'у': 'u', 'ф': 'f', 'х': 'kh', 'ц': 'c', 'ч': 'ch',
            'ш': 'sh', 'щ': 'shh', 'ъ': '', 'ы': 'y', 'ь': '',
            'э': 'e', 'ю': 'yu', 'я': 'ya'
        };
        let string = input.toLowerCase();

        for (let index in char_map) {
            if (char_map.hasOwnProperty(index)) {
                string = string.replace(new RegExp(index, 'g'), char_map[index]);
            }
        }
        string = string.replace(/[^-a-z0-9_.]/g, '-');
        string = string.replace(/^[-_.]*([-a-z0-9_.]*[a-z0-9]+)[-_.]*$/, '$1');
        string = string.replace(/--+/g, '-');

        return string;
    }
};

document.addEventListener('DOMContentLoaded', function () {
    Biovision.csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    // Предварительный просмотр картинки при выборе файла
    document.addEventListener('change', function (event) {
        const input = event.target;

        if (input.matches('input[type=file]')) {
            Biovision.preview_file(input);
        }
    });

    document.addEventListener('click', function (event) {
        const element = event.target;

        // Выбор результата поиска пользователей в админке
        if (element.matches('.user-search .results li')) {
            const container = element.closest('.user-search');
            const target = document.getElementById(container.getAttribute('data-target'));

            target.value = element.getAttribute('data-id');
        }

        // Запирание/отпирание сущности (иконка с замком)
        if (element.matches('li.lock > a img')) {
            event.preventDefault();

            const container = element.closest('li');
            const button = element.closest('a');
            const lockable = container.parentNode.querySelectorAll('.lockable');
            const url = container.getAttribute('data-url');

            if (url.length > 1) {
                const method = button.classList.contains('lock') ? 'PUT' : 'DELETE';

                const request = Biovision.new_ajax_request(method, url, function () {
                    const response = JSON.parse(this.responseText);

                    if (response.hasOwnProperty('data') && response['data'].hasOwnProperty('locked')) {
                        const locked = response['data']['locked'];

                        if (locked) {
                            lockable.forEach(function (button) {
                                button.classList.add('hidden')
                            });
                        } else {
                            lockable.forEach(function (button) {
                                button.classList.remove('hidden')
                            });
                        }

                        container.querySelectorAll('a').forEach(function (button) {
                            const classes = button.classList;

                            if (classes.contains('lock')) {
                                locked ? classes.add('hidden') : classes.remove('hidden');
                            } else {
                                locked ? classes.remove('hidden') : classes.add('hidden');
                            }
                        });
                    }
                });

                request.send();
            }
        }

        // Переключение флагов сущности
        if (element.matches('div.toggleable > span')) {
            if (!element.classList.contains('switch')) {
                const url = element.parentNode.getAttribute('data-url');
                const parameter = element.getAttribute('data-flag');

                const on_success = function() {
                    const response = JSON.parse(this.responseText);

                    if (response.hasOwnProperty('data')) {
                        switch (response['data'][parameter]) {
                            case true:
                                element.className = 'active';
                                break;
                            case false:
                                element.className = 'inactive';
                                break;
                            default:
                                element.className = 'unknown';
                        }
                    } else {
                        element.className = 'unknown';
                    }
                };

                const on_failure = function() {
                    element.className = 'unknown';
                    Biovision.handle_ajax_failure.call(this);
                };

                const request = Biovision.new_ajax_request('POST', url, on_success, on_failure);
                const data = new FormData();
                data.append('parameter', parameter);

                element.className = 'switch';

                request.send(data);
            }
        }

        // Изменение порядка сортировки элементов
        if (element.matches('li.priority-changer > button')) {
            const delta = parseInt(element.getAttribute('data-delta'));
            const url = element.parentNode.getAttribute('data-url');
            let item = element.closest('li[data-number]');

            if (parseInt(item.getAttribute('data-number')) + delta > 0) {
                const on_success = function() {
                    const response = JSON.parse(this.responseText);

                    if (response.hasOwnProperty('data')) {
                        const data = response.data;
                        const container = item.parentNode;
                        const list = Array.prototype.slice.call(container.children);

                        if (data.hasOwnProperty('priority')) {
                            item.setAttribute('data-number', data.priority);
                        } else {
                            for (let entity_id in data) {
                                if (data.hasOwnProperty(entity_id)) {
                                    item = container.querySelector('li[data-id="' + entity_id + '"]');
                                    item.setAttribute('data-number', data[entity_id]);
                                }
                            }
                        }

                        list.sort(function (a, b) {
                            let an = parseInt(a.getAttribute('data-number'));
                            let bn = parseInt(b.getAttribute('data-number'));

                            if (an > bn) {
                                return 1;
                            } else if (an < bn) {
                                return -1;
                            } else {
                                return 0;
                            }
                        }).forEach(function(item) {
                            container.appendChild(item);
                        });
                    }
                };

                const request = Biovision.new_ajax_request('POST', url, on_success);

                const data = new FormData();
                data.append('delta', delta);

                request.send(data);
            }
        }
    });

    // Кнопка поиска пользователя в админке
    document.querySelectorAll('.user-search button').forEach(function (element) {
        element.addEventListener('click', function () {
            const container = this.closest('.user-search');
            const input = container.querySelector('input[type=search]');
            const url = container.getAttribute('data-url') + '?q=' + encodeURIComponent(input.value);

            const request = Biovision.new_ajax_request('GET', url, function () {
                const response = JSON.parse(this.responseText);
                const results = container.querySelector('.results');

                if (response.hasOwnProperty('data')) {
                    results.innerHTML = response['data']['html'];
                }
            });

            request.send();
        });
    });

    // Кнопка удаления элемента через AJAX
    document.querySelectorAll('div[data-destroy-url] button.destroy').forEach(function (element) {
        element.addEventListener('click', function () {
            const container = this.closest('div[data-destroy-url]');
            const url = container.getAttribute('data-destroy-url');
            const request = Biovision.new_ajax_request('DELETE', url, function () {
                container.remove();
            });

            this.setAttribute('disabled', 'true');
            request.send();
        });
    });

    document.querySelectorAll('[data-transliterate]').forEach(function (element) {
        element.addEventListener('blur', function () {
            const target = document.getElementById(element.getAttribute('data-transliterate'));

            if (target && target.value === '') {
                target.value = Biovision.transliterate(element.value);
                target.dispatchEvent(new Event('change'));
            }
        });
    });

    if (typeof jQuery !== 'undefined') {
        jQuery.ajaxSetup({
            headers: {
                'X-CSRF-Token': Biovision.csrf_token
            }
        });
    }
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

/**
 * Element.closest()
 *
 * IE 9+
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Element/closest
 */
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
 * ChildNode.remove()
 *
 * IE 9+
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ChildNode/remove
 */
(function (arr) {
    arr.forEach(function (item) {
        if (item.hasOwnProperty('remove')) {
            return;
        }
        Object.defineProperty(item, 'remove', {
            configurable: true,
            enumerable: true,
            writable: true,
            value: function remove() {
                if (this.parentNode !== null) {
                    this.parentNode.removeChild(this);
                }
            }
        });
    });
})([Element.prototype, CharacterData.prototype, DocumentType.prototype]);
