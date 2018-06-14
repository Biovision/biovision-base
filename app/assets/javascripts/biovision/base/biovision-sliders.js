'use strict';

Biovision.sliders = {
    behavior: {
        opacity: {
            left: function (list, delay) {
                const li = list.querySelector('li:last-of-type');
                const restore_opacity = function () {
                    li.style.opacity = '';
                };

                li.style.opacity = '0';
                list.prepend(li);
                setTimeout(restore_opacity, delay);
            },
            right: function (list, delay) {
                const li = list.querySelector('li:first-of-type');
                const move = function () {
                    list.append(li);
                    li.style.opacity = '';
                };

                li.style.opacity = '0';
                setTimeout(move, delay);
            }
        },
        slide: {
            left: function (list, delay) {
                const li = list.querySelector('li:last-of-type');
                const elementWidth = li.offsetWidth;
                const restore_style = function () {
                    li.style.marginLeft = '';
                };

                li.style.marginLeft = -elementWidth + 'px';
                list.prepend(li);
                setTimeout(restore_style, delay);
            },
            right: function (list, delay) {
                const li = list.querySelector('li:first-of-type');
                const elementWidth = li.offsetWidth;
                const move = function () {
                    list.append(li);
                    li.style.marginLeft = '';
                };
                li.style.marginLeft = -elementWidth + 'px';
                setTimeout(move, delay);
            }
        },
    },
    initialize: function (slider) {
        const delay = slider.getAttribute('data-delay') || 125;
        const list = slider.querySelector('ul');
        let type = slider.getAttribute('data-type') || 'opacity';

        if (!Biovision.sliders.behavior.hasOwnProperty(type)) {
            console.log('Invalid sliding type: ' + type);
            type = 'opacity';
        }

        const slide_right = function () {
            Biovision.sliders.behavior[type].right(list, delay << 1);
        };

        const slide_left = function () {
            Biovision.sliders.behavior[type].left(list, delay);
        };

        const handle_gesture = function () {
            const x0 = Biovision.sliders.touch_state.x0;
            const x1 = Biovision.sliders.touch_state.x1;

            if (x0 < x1) {
                slide_left();
            } else if (x0 > x1) {
                slide_right();
            }
        };

        slider.querySelector('button.prev').addEventListener('click', slide_left);
        slider.querySelector('button.next').addEventListener('click', slide_right);
        slider.addEventListener('touchstart', function (event) {
            Biovision.sliders.touch_state.x0 = event.changedTouches[0].pageX;
            Biovision.sliders.touch_state.y0 = event.changedTouches[0].pageY;
        }, false);
        slider.addEventListener('touchend', function (event) {
            Biovision.sliders.touch_state.x1 = event.changedTouches[0].pageX;
            Biovision.sliders.touch_state.y1 = event.changedTouches[0].pageY;
            handle_gesture();
        }, false);
    },
    touch_state: {x0: 0, y0: 0, x1: 0, y1: 0}
};

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.biovision-slider').forEach(Biovision.sliders.initialize);
});
