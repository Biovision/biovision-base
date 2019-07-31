'use strict';

const Biovision = {
    locale: '',
    csrfToken: '',
    components: {},
    init: function () {
        this.locale = document.querySelector('html').getAttribute('lang');
        this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        if (typeof jQuery !== 'undefined') {
            jQuery.ajaxSetup({
                headers: {
                    'X-CSRF-Token': this.csrfToken
                }
            });
        }

        for (let componentName in this.components) {
            if (this.components.hasOwnProperty(componentName)) {
                const component = this.components[componentName];
                if (component.hasOwnProperty('init')) {
                    component.init();
                }

                if (component.hasOwnProperty("autoInitComponents")) {
                    if (component.autoInitComponents) {
                        this.initChildComponents(component);
                    }
                }
            }
        }
    },
    /**
     * Init child components of given component
     *
     * @type {function}
     * @param {Object} parent
     */
    initChildComponents: function (parent) {
        if (!parent.hasOwnProperty("components")) {
            return;
        }

        for (let componentName in parent.components) {
            if (parent.components.hasOwnProperty(componentName)) {
                const child = parent.components[componentName];

                if (child.hasOwnProperty("init")) {
                    let initialized = false;
                    if (child.hasOwnProperty("initialized")) {
                        initialized = child.initialized;
                    }

                    if (!initialized) {
                        child.init();
                    }
                }
            }
        }
    },
    /**
     * @deprecated use Biovision.newAjaxRequest
     * @param method
     * @param url
     * @param [onSuccess]
     * @param [onFailure]
     */
    new_ajax_request: function (method, url, onSuccess, onFailure) {
        console.log("Biovision.new_ajax_request is deprecated; use Biovision.newAjaxRequest instead");
        return Biovision.newAjaxRequest(method, url, onSuccess, onFailure);
    },
    /**
     * Initialize new AJAX request
     *
     * @param {string} method
     * @param {string} url
     * @param {function} [onSuccess] callback for success
     * @param {function} [onFailure=Biovision.handleAjaxFailure] callback for failure
     * @returns {XMLHttpRequest}
     */
    newAjaxRequest: function (method, url, onSuccess, onFailure) {
        const request = new XMLHttpRequest();

        request.addEventListener('load', function () {
            if (this.status >= 200 && this.status < 400) {
                if (onSuccess) {
                    onSuccess.call(this);
                }
            } else {
                (onFailure || Biovision.handleAjaxFailure).call(this);
            }
        });
        request.addEventListener("error", Biovision.handleAjaxFailure);

        request.open(method.toUpperCase(), url);
        request.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        request.setRequestHeader('X-CSRF-Token', Biovision.csrfToken);

        return request;
    },
    /**
     * Initialize new AJAX request with JSON content-type and accept headers
     *
     * @param {string} method
     * @param {string} url
     * @param {function} onSuccess
     * @param {function} onFailure
     * @returns {XMLHttpRequest}
     */
    jsonAjaxRequest: function (method, url, onSuccess, onFailure) {
        const request = Biovision.newAjaxRequest(method, url, onSuccess, onFailure);

        request.setRequestHeader("Content-Type", "application/json");
        request.setRequestHeader("Accept", "application/json");

        return request;
    },
    /**
     * @deprecated use Biovision.handleAjaxFailure
     * @param response
     */
    handle_ajax_failure: function (response) {
        console.log("Biovision.handle_ajax_failure is deprecated; use Biovision.handleAjaxFailure instead");
        console.log('AJAX failed', this);
        if (response.hasOwnProperty('responseJSON')) {
            console.log(response['responseJSON']);
        } else {
            console.log(response);
        }
    },
    /**
     * Handle failed AJAX request
     *
     * @type {Function}
     */
    handleAjaxFailure: function () {
        console.log('AJAX failed', this);
    },
    /**
     * Показать список ошибок после обработки формы
     *
     * Используется в контроллерах при отправке форм через remote: true
     *
     * @param {string} model_name название модели
     * @param {Array<string>} list список ошибок
     */
    showListOfErrors: function (model_name, list) {
        const form = document.getElementById(model_name + '-form');
        if (form) {
            let errors = form.querySelector('ol.errors');
            let data = '';

            if (!errors) {
                errors = document.createElement('ol');
                errors.classList.add('errors');
            }

            list.forEach(function (message) {
                data += '<li>' + message + '</li>';
            });

            errors.innerHTML = data;

            form.prepend(errors);

            errors.scrollIntoView();
        }
    },
    /**
     * Hide and show elements in form with given id
     *
     * Toggles class "hidden" for elements with selectors
     * hideSelector and showSelector for form children
     *
     * @param {String} formId
     * @param {String} hideSelector elements to hide
     * @param {String} showSelector elements to show
     */
    switchFormElements: function (formId, hideSelector, showSelector) {
        const form = document.getElementById(formId);
        if (form) {
            form.querySelectorAll(showSelector).forEach(function (element) {
                element.classList.remove('hidden');
            });
            form.querySelectorAll(hideSelector).forEach(function (element) {
                element.classList.add('hidden');
            });
        } else {
            console.log('Cannot find element with id ' + formId)
        }
    }
};

/**
 * Show/hide "go to top" link when it is present in layout
 *
 * @type {Object}
 */
Biovision.components.topLinker = {
    /**
     * @type {Boolean}
     */
    initialized: false,
    /**
     * @type {HTMLElement}
     */
    element: undefined,
    /**
     * Initialize component
     */
    init: function () {
        this.element = document.getElementById('go-to-top');

        if (this.element) {
            const topLinker = this.element;

            window.addEventListener('scroll', function () {
                if (window.pageYOffset > 500) {
                    topLinker.classList.remove('inactive');
                } else {
                    topLinker.classList.add('inactive');
                }
            });

            this.initialized = true;
        }
    }
};

/**
 * Preview images when selecting them in input type="file" fields
 *
 * @type {Object}
 */
Biovision.components.filePreview = {
    /**
     * @type {Boolean}
     */
    initialized: false,
    /**
     * Initialize component
     */
    init: function () {
        document.addEventListener('change', function (event) {
            const input = event.target;

            if (input.matches('input[type=file]')) {
                Biovision.components.filePreview.handle(input);
            }
        });
        this.initialized = true;
    },
    /**
     * Handle change of file input field
     *
     * @param {EventTarget|HTMLInputElement} input
     */
    handle: function (input) {
        const targetImage = input.getAttribute('data-image');

        if (targetImage) {
            const target = document.querySelector('#' + targetImage + ' img');

            if (target && input.files && input.files[0]) {
                const reader = new FileReader();

                reader.onload = function (event) {
                    target.setAttribute('src', event.target["result"]);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    },
};

/**
 * Linking entities with checkboxes
 *
 * @type {Object}
 */
Biovision.components.entityLinker = {
    /**
     * @type {Boolean}
     */
    initialized: false,
    selector: '.entity-links input[type=checkbox]',
    /**
     * List of elements with attached event listener
     *
     * @type {Array<HTMLElement>}
     */
    elements: [],
    /**
     * Initialize component
     */
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    /**
     * Apply handler to element
     *
     * @param {HTMLInputElement} element
     */
    apply: function (element) {
        const component = Biovision.components.entityLinker;

        component.elements.push(element);
        element.addEventListener('click', component.handler);
    },
    /**
     * Event handler for clicking on element
     */
    handler: function () {
        const url = this.getAttribute('data-url');

        if (url && !this.disabled) {
            const method = this.checked ? 'put' : 'delete';
            const box = this;

            this.disabled = true;

            Biovision.newAjaxRequest(method, url, function () {
                box.disabled = false
            }).send();
        }
    }
};

/**
 * Instantly check form validity
 *
 * @type {Object}
 */
Biovision.components.instantCheck = {
    initialized: false,
    selector: 'form[data-check-url]',
    elements: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    /**
     *
     * @param {HTMLFormElement} form
     */
    apply: function (form) {
        const component = Biovision.components.instantCheck;

        form.querySelectorAll('[data-check]').forEach(function (element) {
            component.elements.push(element);
            element.addEventListener('blur', component.handler);
        });
    },
    handler: function () {
        const element = this;
        const form = element.closest('form');
        const url = form.getAttribute('data-check-url');

        const request = Biovision.newAjaxRequest('POST', url, function () {
            if (this.responseText) {
                const response = JSON.parse(this.responseText);

                if (response.hasOwnProperty('meta')) {
                    if (response.meta.valid) {
                        form.querySelectorAll('[data-field]').forEach(function (field) {
                            field.innerHTML = '';
                        });
                    } else {
                        const key = element.getAttribute('data-check');
                        const container = form.querySelector('[data-field="' + key + '"]');

                        if (container) {
                            const errors = response.meta['errors'];

                            if (errors.hasOwnProperty(key)) {
                                container.innerHTML = errors[key].join('; ');
                                container.classList.remove('hidden');
                            } else {
                                container.innerHTML = '';
                            }
                        }
                    }
                }
            }
        });

        const data = new FormData();
        Array.from((new FormData(form)).entries()).forEach(function (entry) {
            const value = entry[1];

            if (value instanceof window.File && value.name === '' && value.size === 0) {
                data.append(entry[0], new window.Blob([]), '');
            } else {
                if (entry[0] !== '_method') {
                    data.append(entry[0], value);
                }
            }
        });

        request.send(data);
    }
};

Biovision.components.transliterator = {
    initialized: false,
    selector: '[data-transliterate]',
    elements: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    /**
     *
     * @param {HTMLElement} element
     */
    apply: function (element) {
        const component = Biovision.components.transliterator;

        component.elements.push(element);
        element.addEventListener('blur', component.handler);
    },
    /**
     *
     * @param {Event} event
     */
    handler: function (event) {
        const component = Biovision.components.transliterator;
        const element = event.target;
        const target = document.getElementById(element.getAttribute('data-transliterate'));

        if (target && target.value === '') {
            target.value = component.transliterate(element.value);
            target.dispatchEvent(new Event('change'));
        }
    },
    /**
     *
     * @param {string} input
     * @returns {string}
     */
    transliterate: function (input) {
        const characterMap = {
            'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd',
            'е': 'e', 'ё': 'yo', 'ж': 'zh', 'з': 'z', 'и': 'i',
            'й': 'j', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n',
            'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't',
            'у': 'u', 'ф': 'f', 'х': 'kh', 'ц': 'c', 'ч': 'ch',
            'ш': 'sh', 'щ': 'shh', 'ъ': '', 'ы': 'y', 'ь': '',
            'э': 'e', 'ю': 'yu', 'я': 'ya',
            'å': 'aa', 'ä': 'ae', 'ö': 'oe', 'é': 'e'
        };
        let string = input.toLowerCase();

        for (let index in characterMap) {
            if (characterMap.hasOwnProperty(index)) {
                string = string.replace(new RegExp(index, 'g'), characterMap[index]);
            }
        }
        string = string.replace(/[^-a-z0-9_.]/g, '-');
        string = string.replace(/^[-_.]*([-a-z0-9_.]*[a-z0-9]+)[-_.]*$/, '$1');
        string = string.replace(/--+/g, '-');

        return string;
    },
};

Biovision.components.formStatus = {
    initialized: false,
    selector: 'form[data-remote]',
    elements: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    /**
     *
     * @param {HTMLFormElement} element
     */
    apply: function (element) {
        const component = Biovision.components.formStatus;
        component.elements.push(element);

        const button = element.querySelector('button[type=submit]');
        const loadingMessage = element.querySelector('.loading_message');
        const stateContainer = element.querySelector('.state_container');
        const progressPercent = element.querySelector('.state_container .percentage');
        const progressBar = element.querySelector('.state_container progress');

        element.addEventListener('ajax:before', function () {
            button.disabled = true;

            if (loadingMessage) {
                loadingMessage.classList.remove('hidden');
            }
        });

        element.addEventListener('ajax:complete', function () {
            button.disabled = false;

            if (loadingMessage) {
                loadingMessage.classList.add('hidden');
            }
            if (progressBar) {
                progressBar.value = '0';
            }
        });

        if (stateContainer) {
            element.addEventListener('ajax:beforeSend', function (event) {
                const request = event.detail[0];

                request.upload.addEventListener('progress', function (e) {
                    const value = e.loaded / e.total;

                    if (progressPercent) {
                        progressPercent.innerHTML = (value * 100) + '%';
                    }
                    if (progressBar) {
                        progressBar.value = value;
                    }
                });
            });
        }
    },
};

Biovision.components.autoExpand = {
    initialized: false,
    selector: 'textarea.auto-expand',
    elements: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    /**
     *
     * @param {HTMLTextAreaElement} element
     */
    apply: function (element) {
        const component = Biovision.components.autoExpand;
        component.elements.push(element);

        element.addEventListener('focus', component.handler);
        element.addEventListener('input', component.handler);
    },
    handler: function () {
        if (!this.hasOwnProperty('baseScrollHeight')) {
            let savedValue = this.value;
            this.value = '';
            this.baseScrollHeight = this.scrollHeight;
            this.value = savedValue;
        }
        const styles = getComputedStyle(this);
        const ratio = styles.getPropertyValue('line-height').replace('px', '');
        const minRows = this.getAttribute('data-min-rows') | 0;
        const maxRows = this.hasAttribute('data-max-rows') ? parseInt(this.getAttribute('data-max-rows')) : 25;
        const rows = Math.ceil((this.scrollHeight - this.baseScrollHeight) / ratio);

        this.rows = minRows;
        this.rows = minRows + rows;
        if (this.rows > maxRows) {
            this.rows = maxRows;
        }
    }
};

Biovision.components.entityImageRemover = {
    initialized: false,
    selector: '.remove-image-button',
    elements: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const component = Biovision.components.entityImageRemover;
        component.elements.push(element);
        element.addEventListener('click', component.handler);
    },
    handler: function () {
        const button = this;
        if (!button.disabled) {
            const message = button.getAttribute('data-text');
            if (confirm(message)) {
                const url = button.getAttribute('data-url');
                const request = Biovision.newAjaxRequest('delete', url, function () {
                    if (this.responseText) {
                        const response = JSON.parse(this.responseText);
                        const term = document.getElementById('entity-image');

                        console.log(response);

                        if (term) {
                            term.remove();
                        }
                        button.parentNode.parentNode.remove();
                    }
                });

                button.disabled = true;

                request.send();
            }
        }
    }
};

Biovision.components.ajaxDeleteButton = {
    initialized: false,
    selector: 'button.destroy[data-url]',
    elements: [],
    messages: {
        "ru": "Вы уверены?",
        "en": "Are you sure?"
    },
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const component = Biovision.components.ajaxDeleteButton;
        component.elements.push(element);
        element.addEventListener('click', component.handler);
    },
    handler: function (event) {
        const messages = Biovision.components.ajaxDeleteButton.messages;
        const element = event.target;
        const message = messages.hasOwnProperty(Biovision.locale) ? messages[Biovision.locale] : 'Are you sure?';

        element.disabled = true;

        if (confirm(message)) {
            const url = element.getAttribute('data-url');
            const request = Biovision.newAjaxRequest('delete', url, function () {
                element.closest('li[data-id]').remove();
            });
            request.send();
        }

        element.disabled = false;
    }
};

Biovision.components.storage = {
    initialized: false,
    session: {
        set: function (key, value) {
            Biovision.components.storage.set('sessionStorage', key, value);
        },
        get: function (key) {
            return Biovision.components.storage.get('sessionStorage', key);
        },
        remove: function (key) {
            Biovision.components.storage.remove('sessionStorage', key);
        }
    },
    local: {
        set: function (key, value) {
            Biovision.components.storage.set('localStorage', key, value);
        },
        get: function (key) {
            return Biovision.components.storage.get('localStorage', key);
        },
        remove: function (key) {
            Biovision.components.storage.remove('localStorage', key);
        }
    },
    init: function () {
        Biovision.storage = this;
        this.initialized = true;
    },
    available: function (type) {
        try {
            const x = '__storage_test__';

            window[type].setItem(x, x);
            window[type].removeItem(x);

            return true;
        } catch (e) {
            return false;
        }
    },
    set: function (type, key, value) {
        if (Biovision.components.storage.available(type)) {
            window[type].setItem(key, value);
        } else {
            console.log('set: Storage ' + type + ' is not available');
        }
    },
    get: function (type, key) {
        if (Biovision.components.storage.available(type)) {
            return window[type].getItem(key);
        } else {
            console.log('get: Storage ' + type + ' is not available');
            return null;
        }
    },
    remove: function (type, key) {
        if (Biovision.components.storage.available(type)) {
            window[type].removeItem(key);
        } else {
            console.log('remove: Storage ' + type + ' is not available');
        }
    }
};

// Кнопка удаления элемента через AJAX
Biovision.components.destroyButton = {
    initialized: false,
    selector: 'div[data-destroy-url] button.destroy',
    elements: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const component = Biovision.components.destroyButton;
        component.elements.push(element);
        element.addEventListener('click', component.handler);
    },
    handler: function () {
        const container = this.closest('div[data-destroy-url]');
        const url = container.getAttribute('data-destroy-url');
        const request = Biovision.newAjaxRequest('DELETE', url, function () {
            container.remove();
        });

        this.setAttribute('disabled', 'true');
        request.send();
    }
};

// Поиск пользователя в админке
Biovision.components.userSearch = {
    initialized: false,
    selector: '.user-search button',
    elements: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const component = Biovision.components.userSearch;
        component.elements.push(element);
        element.addEventListener('click', component.handler);
    },
    handler: function () {
        const container = this.closest('.user-search');
        const input = container.querySelector('input[type=search]');
        const url = container.getAttribute('data-url') + '?q=' + encodeURIComponent(input.value);

        const request = Biovision.newAjaxRequest('GET', url, function () {
            const response = JSON.parse(this.responseText);
            const results = container.querySelector('.results');

            if (response.hasOwnProperty('data')) {
                results.innerHTML = response['data']['html'];

                results.querySelectorAll('li').forEach(function (li) {
                    li.addEventListener('click', function (event) {
                        const element = event.target;
                        const target = document.getElementById(container.getAttribute('data-target'));

                        target.value = element.getAttribute('data-id');
                    });
                });
            }
        });

        request.send();
    }
};

/**
 * Hide popups when clicking outside
 *
 * @type {Object}
 */
Biovision.components.hidingPopups = {
    /**
     * @type {Boolean}
     */
    initialized: false,
    /**
     * @type {String}
     */
    selector: '.hiding-popup-container .popup-control',
    /**
     * List of control checkboxes
     *
     * @type {Array<HTMLInputElement>}
     */
    elements: [],
    /**
     * Initialize component
     */
    init: function () {
        const component = this;
        this.elements = [];
        document.querySelectorAll(this.selector).forEach(component.addElement);
        document.addEventListener('click', component.handler);

        this.initialized = true;
    },
    /**
     * Add container to list
     *
     * @param {HTMLInputElement} element
     */
    addElement: function (element) {
        Biovision.components.hidingPopups.elements.push(element);
    },
    /**
     * Handle click
     *
     * @param {Event} event
     * @type {Function}
     */
    handler: function (event) {
        const component = Biovision.components.hidingPopups;
        const selector = '.hiding-popup-container *';
        const target = event.target;

        if (target.matches(selector)) {
            const container = target.closest('.hiding-popup-container');
            const checkbox = container.querySelector(component.selector);
            component.elements.forEach(function (element) {
                if (element !== checkbox) {
                    element.checked = false;
                }
            });
        } else {
            component.elements.forEach(function (checkbox) {
                checkbox.checked = false;
            });
        }
    }
};

Biovision.components.componentParameters = {
    initialized: false,
    container: undefined,
    url: undefined,
    list: undefined,
    elements: [],
    init: function () {
        this.container = document.getElementById("biovision-component-parameters");
        if (this.container) {
            this.url = this.container.getAttribute("data-url");
            this.list = this.container.querySelector("dl");
            this.list.querySelectorAll("input").forEach(this.apply);
            this.initialized = true;
        }
    },
    /**
     *
     * @param {HTMLElement} element
     * @type {Function}
     */
    apply: function (element) {
        const component = Biovision.components.componentParameters;
        component.elements.push(element);
        element.addEventListener("change", component.change);
    },
    change: function (event) {
        const component = Biovision.components.componentParameters;
        const element = event.target;
        const data = {
            "key": {
                "slug": element.name,
                "value": element.value
            }
        };
        const request = Biovision.jsonAjaxRequest("patch", component.url, function () {
            element.disabled = false;
            element.classList.add("updated");
        }, function () {
            element.disabled = false;
            element.classList.add("failed");
        });

        element.classList.remove("updated", "failed");
        element.disabled = true;
        request.send(JSON.stringify(data));
    },
    add: function (data) {
        const div = document.createElement("div");
        const dt = document.createElement("dt");
        const label = document.createElement("label");
        const elementId = "parameter-" + data["slug"];
        label.setAttribute("for", elementId);
        label.innerHTML = data["slug"];
        dt.append(label);
        const dd = document.createElement("dd");
        const input = document.createElement("input");
        input.setAttribute("id", elementId);
        input.setAttribute("name", data["slug"]);
        input.value = data["value"];
        dd.append(input);
        this.apply(input);
        div.append(dt);
        div.append(dd);
        this.list.append(div);
    }
};

Biovision.components.newComponentParameter = {
    initialized: false,
    container: undefined,
    url: undefined,
    button: undefined,
    init: function () {
        this.container = document.getElementById("biovision-component-new-parameter");
        if (this.container) {
            const component = this;
            this.url = this.container.getAttribute("data-url");
            this.button = this.container.querySelector("button");
            this.button.addEventListener("click", component.click);
            this.initialized = true;
        }
    },
    click: function () {
        const component = Biovision.components.newComponentParameter;
        const data = {"key": {}};
        let dataPresent = true;
        component.container.querySelectorAll("input").forEach(function (input) {
            dataPresent &= input.value.length > 0;
            data.key[input.name] = input.value;
        });

        if (dataPresent) {
            const request = Biovision.jsonAjaxRequest("patch", component.url, function () {
                component.container.querySelectorAll("input").forEach(function (input) {
                    input.value = '';
                });
                Biovision.components.componentParameters.add(data["key"]);
                component.button.disabled = false;
            }, function () {
                component.button.disabled = false;
            });

            component.button.disabled = true;
            request.send(JSON.stringify(data));
        }
    }
};

document.addEventListener('DOMContentLoaded', function () {
    Biovision.init();

    document.addEventListener('click', function (event) {
        const element = event.target;

        // Запирание/отпирание сущности (иконка с замком)
        if (element.matches('li.lock > a img')) {
            event.preventDefault();

            const container = element.closest('li');
            const button = element.closest('a');
            const lockable = container.parentElement.querySelectorAll('.lockable');
            const url = container.getAttribute('data-url');

            if (url.length > 1) {
                const method = button.classList.contains('lock') ? 'PUT' : 'DELETE';

                const request = Biovision.newAjaxRequest(method, url, function () {
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

                const onSuccess = function () {
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

                const onFailure = function () {
                    element.className = 'unknown';
                    Biovision.handleAjaxFailure().call(this);
                };

                const request = Biovision.newAjaxRequest('POST', url, onSuccess, onFailure);
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
                const onSuccess = function () {
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
                        }).forEach(function (item) {
                            container.appendChild(item);
                        });
                    }
                };

                const request = Biovision.newAjaxRequest('POST', url, onSuccess);

                const data = new FormData();
                data.append('delta', String(delta));

                request.send(data);
            }
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

/**
 * Workaround for defective Safari behaviour with empty files
 * @see https://github.com/rails/rails/issues/32440
 */
document.addEventListener('ajax:beforeSend', function (e) {
    const formData = e.detail[1].data;

    if (!(formData instanceof FormData) || !formData.keys) {
        return;
    }

    const newFormData = new FormData();

    Array.from(formData.entries()).forEach(function (entry) {
        const value = entry[1];

        if (value instanceof window.File && value.name === '' && value.size === 0) {
            newFormData.append(entry[0], new window.Blob([]), '');
        } else {
            newFormData.append(entry[0], value);
        }
    });

    e.detail[1].data = newFormData
});
