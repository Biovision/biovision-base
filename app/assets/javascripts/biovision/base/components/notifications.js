"use strict";

const Notifications = {
    initialized: false,
    autoInitComponents: true,
    components: {},
    init: function () {
        this.initialized = true;
    }
};

Notifications.components.markAsRead = {
    initialized: false,
    selector: ".notifications-list .unread",
    items: {},
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const component = Notifications.components.markAsRead;
        const id = element.getAttribute("data-id");
        component.items[id] = element;
        element.addEventListener("mouseover", component.handler);
    },
    handler: function (event) {
        const component = Notifications.components.markAsRead;
        const element = event.target.closest(".unread");
        if (element) {
            const url = element.getAttribute("data-url");
            Biovision.jsonAjaxRequest("put", url, function () {
                element.classList.remove("unread");
            }).send();
            element.removeEventListener("mouseover", component.handler);
        }
    }
};

Notifications.components.deleteNotification = {
    initialized: false,
    selector: ".notifications-list button",
    items: {},
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const li = element.closest("li");
        const id = li.getAttribute("data-id");
        const component = Notifications.components.deleteNotification;
        component.items[id] = element;
        element.addEventListener("click", component.handler);
    },
    handler: function (event) {
        const button = event.target;
        const url = button.getAttribute("data-url");
        button.disabled = true;
        const request = Biovision.jsonAjaxRequest("delete", url, function () {
            button.closest("li").remove();
        });

        request.send();
    }
};

Biovision.components.notifications = Notifications;