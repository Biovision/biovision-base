"use strict";

/**
 * Socialization component for Biovision-based sites
 *
 * @author Maxim Khan-Magomedov
 * @type {Object}
 */
const Socialization = {
    initialized: false,
    components: {},
    autoInitComponents: true,
    init: function () {
        this.initialized = true;
    }
};

/**
 * Sending messages to other users
 *
 * @type {Object}
 */
Socialization.components.messageSender = {
    /**
     * @type {Boolean}
     */
    initialized: false,
    /**
     * HTML id for selecting container
     *
     * @type {String}
     */
    selector: "user_messages",
    /**
     * Container for widget
     *
     * @type {HTMLDivElement}
     */
    container: undefined,
    /**
     * UL element for displaying messages
     *
     * @type {HTMLUListElement}
     */
    list: undefined,
    /**
     * "Send" button
     *
     * @type {HTMLButtonElement}
     */
    button: undefined,
    /**
     * Textarea field for entering new message text
     *
     * @type {HTMLTextAreaElement}
     */
    field: undefined,
    /**
     * Loader button for receiving next page
     *
     * @type {HTMLButtonElement}
     */
    loader: undefined,
    /**
     * URL for new messages
     *
     * @type {String}
     */
    url: undefined,
    init: function () {
        this.container = document.getElementById(this.selector);
        if (this.container) {
            this.url = this.container.getAttribute("data-url");
            this.list = this.container.querySelector(".user_messages-list");
            this.field = this.container.querySelector("textarea");
            this.button = this.container.querySelector(".actions button");
            this.loader = this.container.querySelector(".user_messages-loader");

            this.field.addEventListener("keyup", this.keyup);
            this.button.addEventListener("click", this.send);
            this.loader.addEventListener("click", this.loadMessages);

            this.initialized = true;

            this.loadMessages();
        }
    },
    /**
     * Handler for checking new message length
     *
     * @type {Function}
     */
    keyup: function () {
        const component = Socialization.components.messageSender;
        const message = component.field.value.trim();
        component.button.disabled = message.length < 1;
    },
    send: function () {
        const component = Socialization.components.messageSender;
        const request = Biovision.jsonAjaxRequest("post", component.url, component.processPost, null);
        const data = {
            "user_message": {
                "body": component.field.value
            }
        };

        component.button.disabled = true;
        request.send(JSON.stringify(data));
    },
    processPost: function () {
        const component = Socialization.components.messageSender;
        const response = JSON.parse(this.responseText);
        if (response.hasOwnProperty("data")) {
            component.addMessage(response.data, true);
            component.field.value = "";
        }
    },
    /**
     * Append or prepend message to list
     *
     * @param {Object} data
     * @param {boolean} append
     * @type {Function}
     */
    addMessage: function (data, append) {
        const component = Socialization.components.messageSender;
        if (data.hasOwnProperty("meta")) {
            const li = document.createElement("li");
            li.classList.add(data["meta"]["direction"]);
            li.innerHTML = data["meta"]["html"];
            if (append) {
                component.list.append(li);
            } else {
                component.list.prepend(li);
            }
        }
    },
    /**
     * @type {Function}
     */
    loadMessages: function () {
        const component = Socialization.components.messageSender;
        const url = component.loader.getAttribute("data-url");
        const request = Biovision.jsonAjaxRequest("get", url, component.processGet, null);
        component.loader.disabled = true;
        request.send();
    },
    processGet: function () {
        const component = Socialization.components.messageSender;
        const response = JSON.parse(this.responseText);
        if (response.hasOwnProperty("data")) {
            response["data"].forEach(function (data) {
                component.addMessage(data, false);
            });
            component.loader.disabled = false;
        }
        if (response.hasOwnProperty("links")) {
            if (response["links"].hasOwnProperty("next")) {
                component.loader.setAttribute("data-url", response["links"]["next"]);
            } else {
                component.loader.remove();
            }
        } else {
            component.loader.remove();
        }
    }
};

Biovision.components.socialization = Socialization;
