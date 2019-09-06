"use strict";

Biovision.components.animatedNumbers = {
    initialized: false,
    selector: ".js-animated-numbers",
    containers: [],
    breakpoints: {},
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.addContainer);
        this.initialized = true;
    },
    addContainer: function (element) {
        const component = Biovision.components.animatedNumbers;
        const container = {
            "element": element,
            "items": []
        };
        if (element.hasAttribute("data-time")) {
            container["time"] = parseInt(element.getAttribute("data-time"));
        } else {
            container["time"] = 3000;
        }
        container["stepCount"] = Math.ceil(container["time"] / 50);
        element.querySelectorAll(".value").forEach(function (value) {
            component.addItem(container, value);
        });
        component.containers.push(container);
        component.animate(container);
    },
    addItem: function (container, element) {
        const item = {
            "element": element,
            "initialValue": parseInt(element.innerHTML),
            "stepNumber": 0,
        };
        container.items.push(item);
    },
    animate: function (container) {
        const component = Biovision.components.animatedNumbers;
        container.items.forEach(function (item) {
            component.increment(item, container.stepCount)
        });
    },
    increment: function (item, stepCount) {
        const component = Biovision.components.animatedNumbers;
        if (item.stepNumber < stepCount) {
            item.stepNumber++;
            item.element.innerHTML = Math.min(Math.ceil(item.initialValue / stepCount * item.stepNumber), item.initialValue);

            window.setTimeout(component.increment, 50, item, stepCount);
        }
    }
};
