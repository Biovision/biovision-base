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
        }
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

        slider.querySelector('button.prev').addEventListener('click', slide_left);
        slider.querySelector('button.next').addEventListener('click', slide_right);
    }
};

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.biovision-slider').forEach(Biovision.sliders.initialize);
});
