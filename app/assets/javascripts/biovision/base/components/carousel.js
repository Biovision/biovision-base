"use strict";

Biovision.components.carousel = {
    /**
     * Component is initialized
     *
     * @type {Boolean}
     */
    initialized: false,
    /**
     * Selector string for matching carousel containers
     *
     * @type {String}
     */
    selector: ".js-biovision-carousel",
    /**
     * Wrappers for found carousel containers
     *
     * @type {Array<Object>}
     */
    sliders: [],
    /**
     * Initializer
     */
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    /**
     * Apply carousel behavior to container
     *
     * @param {HTMLElement} element
     */
    apply: function (element) {
        const component = Biovision.components.carousel;
        const slider = {
            "element": element,
            "container": element.querySelector(".carousel-container"),
            "items": element.querySelectorAll(".carousel-item"),
            "prevButton": element.querySelector("button.prev"),
            "nextButton": element.querySelector("button.next"),
            "current": 0,
            "touchData": {"x": null, "y": null}
        };
        if (element.hasAttribute("data-type")) {
            slider["type"] = element.getAttribute("data-type");
        } else {
            slider["type"] = "offset";
        }
        if (element.hasAttribute("data-timeout")) {
            slider["timeout"] = parseInt(element.getAttribute("data-timeout"));
            if (slider["timeout"] > 0) {
                slider["timeout_handler"] = window.setInterval(component.nextItem, slider["timeout"], slider);
            }
        }
        if (slider["prevButton"]) {
            slider["prevButton"].addEventListener("click", component.clickedPrev);
        }
        if (slider["nextButton"]) {
            slider["nextButton"].addEventListener("click", component.clickedNext);
        }
        slider["maxItem"] = slider["items"].length - 1;
        element.addEventListener("touchstart", component.touchStart, false);
        element.addEventListener("touchend", component.touchEnd, false);
        component.sliders.push(slider);
        component.rearrange(slider);
    },
    /**
     * Rearrange items in carousel
     *
     * @param {Object} slider
     */
    rearrange: function (slider) {
        const component = Biovision.components.carousel;
        switch (slider["type"]) {
            case "current-item":
                component.newCurrentItem(slider);
                break;
            case "offset":
                component.setMaxItem(slider);
                component.newOffset(slider);
                break;
            default:
                console.log("Unknown carousel type: " + slider["type"]);
                component.newOffset(slider);
        }
    },
    /**
     * Handler for clicking "Previous" button
     *
     * @param {Event} event
     */
    clickedPrev: function (event) {
        const component = Biovision.components.carousel;
        const slider = component.getSlider(event.target);
        component.prevItem(slider);
    },
    /**
     * Handler for clicking "Next" button
     *
     * @param {Event} event
     */
    clickedNext: function (event) {
        const component = Biovision.components.carousel;
        const slider = component.getSlider(event.target);
        component.nextItem(slider);
    },
    /**
     * Get wrapper for slider
     *
     * @param {HTMLElement|EventTarget} element
     * @returns {Object}
     */
    getSlider: function (element) {
        const slider = element.closest(this.selector);
        for (let i = 0; i < this.sliders.length; i++) {
            if (this.sliders[i].element === slider) {
                return this.sliders[i];
            }
        }
    },
    /**
     * Slide to next item
     *
     * @param {Object} slider
     */
    nextItem: function (slider) {
        const component = Biovision.components.carousel;

        slider["current"]++;
        if (slider["current"] > slider["maxItem"]) {
            slider["current"] = 0;
        }

        component.rearrange(slider);
    },
    /**
     * Slide to previous item
     *
     * @param {Object} slider
     */
    prevItem: function (slider) {
        const component = Biovision.components.carousel;
        slider["current"]--;
        if (slider["current"] < 0) {
            slider["current"] = slider["maxItem"];
        }

        component.rearrange(slider);
    },
    /**
     * Mark new item as current
     *
     * @param {Object} slider
     */
    newCurrentItem: function (slider) {
        const selector = ".carousel-item:nth-of-type(" + (slider.current + 1) + ")";
        const currentSlide = slider.container.querySelector(".carousel-item.current");
        if (currentSlide) {
            currentSlide.classList.remove("current");
        }
        slider.container.querySelector(selector).classList.add("current");
    },
    /**
     * Change margin of the leftmost slide
     *
     * @param {Object} slider
     */
    newOffset: function (slider) {
        const firstSlide = slider.container.querySelector(".carousel-item:first-of-type");
        const rightMargin = window.getComputedStyle(firstSlide).marginRight;
        const slideWidth = firstSlide.offsetWidth + parseInt(rightMargin);
        let newMargin = -(slideWidth * slider.current);
        const slidesLength = slideWidth * slider.items.length;
        const maxOffset = slidesLength - slider.container.offsetWidth;
        const delta = newMargin + maxOffset;

        if (delta < 0) {
            newMargin -= delta;
            slider["current"] = slider["maxItem"];
        }

        firstSlide.style.marginLeft = String(newMargin) + "px";
    },
    /**
     * Determine maximum item number so that right margin remains minimal
     *
     * @param {Object} slider
     */
    setMaxItem: function (slider) {
        const firstSlide = slider.container.querySelector(".carousel-item:first-of-type");
        const rightMargin = window.getComputedStyle(firstSlide).marginRight;
        const slideWidth = firstSlide.offsetWidth + parseInt(rightMargin);
        const maxCount = slider.container.offsetWidth / slideWidth;
        slider["maxItem"] = slider.items.length - Math.floor(maxCount);
    },
    /**
     * Handler for start of swipe
     *
     * @param {TouchEvent} event
     * @type {Function}
     */
    touchStart: function (event) {
        const component = Biovision.components.carousel;
        const slider = component.getSlider(event.target);
        slider["touchData"] = {
            "x": event.changedTouches[0].pageX,
            "y": event.changedTouches[0].pageY
        }
    },
    /**
     * Handler for end of swipe
     *
     * @param {TouchEvent} event
     * @type {Function}
     */
    touchEnd: function (event) {
        const component = Biovision.components.carousel;
        const slider = component.getSlider(event.target);
        const x = event.changedTouches[0].pageX;
        const y = event.changedTouches[0].pageY;
        const deltaX = Math.abs(x - slider["touchData"]["x"]);
        const deltaY = Math.abs(y - slider["touchData"]["y"]);
        if (deltaX > deltaY) {
            if (x < slider["touchData"]["x"]) {
                component.nextItem(slider);
            } else if (x > slider["touchData"]["x"]) {
                component.prevItem(slider);
            }
        }
        slider["touchData"] = {"x": null, "y": null}
    }
};
