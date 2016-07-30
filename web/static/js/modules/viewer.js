$(function(){
  if (window.layout === 'viewer') {
    var number_diff = 1,
        is_footer = false,
        maxImgNumber = $('img').length;

    $(window).scroll(function() {
        $('.js_firebook_a').each(function(){
            var img_pos = $(this).offset().top,
                scroll = $(window).scrollTop(),
                window_height = $(window).height();

            if (scroll > img_pos - window_height){
                number_diff = parseInt($(this).attr('data-index'));
                $('#number').text(number_diff);
            }
        });
    });

    $('body').keydown(function(e){
        var jumpnum = 0,
            key_code = e.keyCode,
            order_position;

        if (key_code != 38 && key_code != 40) {
            return ;
        }

        if (key_code == 38) {
            if (is_footer) {
                jumpnum = parseInt($('#number').text());
                order_position = $('.js_firebook_a[data-index='+(jumpnum)+']').offset();
            } else {
                jumpnum = parseInt($('#number').text()) - 1;
                order_position = $('.js_firebook_a[data-index='+(jumpnum - 1)+']').offset();
            }
            if (order_position == undefined) {
                return ;
            }
        } else if(key_code == 40) {
            jumpnum = parseInt($('#number').text());
            order_position = $('.js_firebook_a[data-index='+(jumpnum)+']').offset();
        }

        if (order_position != undefined && jumpnum < maxImgNumber) {
            order_position = order_position.top;
            is_footer = false;
        } else {
            order_position = $('.js_firebook_a[data-index=0]').offset().top;
            is_footer = true;
        }


        $('html,body').animate({ scrollTop: order_position }, 'fast');
     });

    $('.js_firebook').on('click', function(){
        var order_data_index = $(this).attr('data-index'),
            order_position;

        if (order_data_index == -1) {
            order_position = $('#footerClose').offset();
        } else {
            order_position = $('.js_firebook_a[data-index='+(parseInt(order_data_index) + 1)+']').offset();
        }

        if (order_position == undefined || order_data_index >= (maxImgNumber - 1)) {
            order_position = $('.js_firebook_a[data-index=0]').offset().top;
        } else {
            order_position = order_position.top;
        }

        $('html,body').animate({ scrollTop: order_position }, 'fast');
     });

     $('#size_window').on('click', function(){
         $(this).text('デフォルト表示');
         $('#size_big').html('<a>原寸大表示</a>');
         var window_height = $(window).height() - 100;
         var window_width = $(window).width() - 30;
         $('#img_window img').css('max-height',window_height);
         $('#img_window img').css('max-width',window_width);
     });

     $('#size_big').on('click', function(){
         $(this).text('原寸大表示');
         $('#size_window').html('<a>デフォルト表示</a>');
         $('#img_window img').css('max-height', '');
         $('#img_window img').css('max-width', '');
     });

     $('#size_window').trigger("click");
   }
});
