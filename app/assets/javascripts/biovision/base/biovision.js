"use strict";

$(function () {
    $(document).on('change', 'input[type=file]', function () {
        if ($(this).data('image')) {
            var target = $('#' + $(this).data('image')).find('img');
            var input = this;

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    target.attr('src', e.target.result);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    });

    $(document).on('click', 'div.toggleable > span', function () {
        if (!$(this).hasClass('switch')) {
            var $flag = $(this);
            var url = $(this).parent().data('url');
            var parameter = $(this).data('flag');

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
        var $container = $(this).closest('li');
        var $edit = $container.parent().find('.lockable');
        var url = $container.data('url');

        if (url.length > 1) {
            $.ajax(url, {
                method: $(this).hasClass('lock') ? 'put' : 'delete',
                success: function (response) {
                    if (response.hasOwnProperty('data') && response['data'].hasOwnProperty('locked')) {
                        var locked = response['data']['locked'];

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
        var $li = $(this).closest('li[data-number]');
        var delta = parseInt($(this).data('delta'));
        var url = $(this).parent().data('url');

        if (parseInt($li.data('number')) + delta > 0) {
            $.post(url, {delta: delta}, function (response) {
                console.log(response);
                if (response.hasOwnProperty('data')) {
                    var $container = $li.parent();
                    var $list = $container.children('li');

                    if (response['data'].hasOwnProperty('priority')) {
                        $li.data('number', response['data']['priority']);
                        $li.attr('data-number', response['data']['priority']);
                    } else {
                        for (var entity_id in response['data']) {
                            if (response['data'].hasOwnProperty(entity_id)) {
                                $li = $container.find('li[data-id=' + entity_id + ']');
                                $li.data('number', response['data'][entity_id]);
                                $li.attr('data-number', response['data'][entity_id]);
                            }
                        }
                    }
                    $list.sort(function (a, b) {
                        var an = parseInt($(a).data('number'));
                        var bn = parseInt($(b).data('number'));

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
        var $button = $(this);
        var $container = $(this).closest('div[data-destroy-url]');

        $button.attr('disabled', true);

        $.ajax($container.data('destroy-url'), {
            method: 'delete',
            success: function (response) {
                $container.remove();
            }
        }).fail(handle_ajax_failure);
    });
});

function handle_ajax_failure(response) {
    if (response.hasOwnProperty('responseJSON')) {
        console.log(response['responseJSON']);
    } else {
        console.log(response);
    }
}
