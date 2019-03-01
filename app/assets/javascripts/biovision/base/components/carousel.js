"use strict";

Biovision.components.carousel = {
    initialized: false,
    selector: '.js-biovision-carousel',
    sliders: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const component = Biovision.components.carousel;
        const slider = {
            "element": element,
            "container": element.querySelector(".carousel-container"),
            "items": element.querySelectorAll(".carousel-item"),
            "prevButton": element.querySelector("button.prev"),
            "nextButton": element.querySelector("button.next"),
            "current": 0
        };
        if (element.hasAttribute("data-type")) {
            slider["type"] = element.getAttribute("data-type");
        } else {
            slider["type"] = "offset";
        }
        if (element.hasAttribute("data-timeout")) {
            slider["timeout"] = parseInt(element.getAttribute("data-timeout"));
            slider["timeout_handler"] = window.setInterval(component.nextItem, slider["timeout"], slider);
        }
        if (slider["prevButton"]) {
            slider["prevButton"].addEventListener('click', component.clickedPrev);
        }
        if (slider["nextButton"]) {
            slider["nextButton"].addEventListener('click', component.clickedNext);
        }
        slider["maxItem"] = slider["items"].length - 1;
        component.sliders.push(slider);
        component.rearrange(slider);
    },
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
    clickedPrev: function (event) {
        const component = Biovision.components.carousel;
        const slider = component.sliderForButton(event.target);
        component.prevItem(slider);
    },
    clickedNext: function (event) {
        const component = Biovision.components.carousel;
        const slider = component.sliderForButton(event.target);
        component.nextItem(slider);
    },
    sliderForButton: function (button) {
        const element = button.closest(this.selector);
        for (let i = 0; i < this.sliders.length; i++) {
            if (this.sliders[i].element === element) {
                return this.sliders[i];
            }
        }
    },
    nextItem: function (slider) {
        const component = Biovision.components.carousel;

        slider["current"]++;
        if (slider["current"] > slider["maxItem"]) {
            slider["current"] = 0;
        }

        component.rearrange(slider);
    },
    prevItem: function (slider) {
        const component = Biovision.components.carousel;
        slider["current"]--;
        if (slider["current"] < 0) {
            slider["current"] = slider["maxItem"];
        }

        component.rearrange(slider);
    },
    newCurrentItem: function (slider) {
        const selector = '.carousel-item:nth-of-type(' + (slider.current + 1) + ')';
        const currentSlide = slider.container.querySelector('.carousel-item.current');
        if (currentSlide) {
            currentSlide.classList.remove('current');
        }
        slider.container.querySelector(selector).classList.add('current');
    },
    newOffset: function (slider) {
        const firstSlide = slider.container.querySelector('.carousel-item:first-of-type');
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

        firstSlide.style.marginLeft = String(newMargin) + 'px';
    },
    setMaxItem: function (slider) {
        const firstSlide = slider.container.querySelector('.carousel-item:first-of-type');
        const rightMargin = window.getComputedStyle(firstSlide).marginRight;
        const slideWidth = firstSlide.offsetWidth + parseInt(rightMargin);
        const maxCount = slider.container.offsetWidth / slideWidth;
        slider["maxItem"] = slider.items.length - Math.floor(maxCount);
    }
};
