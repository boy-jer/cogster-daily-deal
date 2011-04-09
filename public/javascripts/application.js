$(document).ready(function() {
  $('.new_window').click(function(e) {
    e.preventDefault();
    var name = 'new_window' + Math.random();
    window.open($(this).attr('href'));
  });

  $('#terms_link').click(function(e) {
    e.preventDefault();
    window.open($(this).attr('href'), 
                'popup',
                'width=650,height=700,scrollbars=yes,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'
    );
  });
  $('#search').focus(function() {
      if ($(this).val() == 'Find Merchant...') {
          $(this).attr('value', '');
      }
  });
  $('#search').blur(function() {
      if ($(this).val() == '') {
          $(this).attr('value', 'Find Merchant...');
      }
  });
  $('#region_listing').mouseover(function() {
    $('#region_listing ul li ul').css('display', 'block');
    $('#region_listing ul li h2').css('background', 'transparent url("/images/region-arrow.png") no-repeat 287px 10px');
  });

  $('#region_listing').mouseout(function() {
    $('#region_listing ul li ul').css('display', 'none');
    $('#region_listing ul li h2').css('background', 'transparent url("/images/region-arrow_closed.png") no-repeat 290px 6px');
  });
    
    $('#region_selection').mouseover(function(e) {
      $(this).children('ul').css('display', 'block');
      $(this).children('strong').css('background', '#1a1b1b url(/images/images8/current_region_dropdown_arrow_down.png) no-repeat 95% center !important');
    });
    $('#region_selection').mouseout(function(e) {
      $(this).children('ul').css('display', 'none');
      $(this).children('strong').css('background', 'transparent url(/assets/images/images8/current_region_dropdown_arrow_left.png) no-repeat 95% center !important');
      $(this).children('strong a').css('color', '#FD9C00');
    });
    $('.datepicker').datepicker({
      showOn: "button",
      buttonImage: "/images/calendar.gif",
      buttonImageOnly: true
    })
    $('#add-new-increment').click(function(e) {
      e.preventDefault();
      var rows = $(this).closest('table').find('tbody tr');
      var row = rows.last().clone();
      var length = rows.length;
      var replacement = $('<tr />').append(row.html().replace(/\[\d\]/, '[' + length + ']'));
      $(this).closest('table').find('tbody').append(replacement);
    });
    $('#business_sort_selection').mouseover(function(e) {
      $(this).css('background', '#1A1B1B url(/images/images8/business_sort_arrow_down.png) no-repeat 95% 10%');
      $(this).children('ul').css('display', 'block');
      $(this).children('strong').css('color', 'white');
    });
    $('#business_sort_selection').mouseout(function(e) {
      $(this).css('background', 'transparent url(/images/images8/business_sort_arrow_left.png) no-repeat 95% 50%');
      $(this).children('ul').css('display', 'none');
      $(this).children('strong').css('color', '#53535B');
    }); 
        
    if($('.return_rate_period')) { 
      var redemption_ratios = [];
      var redemption_amounts = $('.return_rate_period')
      var purchase = $('#investment_amount').val();
      redemption_amounts.each(function(index) {
        var num = $(redemption_amounts[index]).html().replace(/[^0-9]/g,'');
        redemption_ratios.push(parseInt(num) / purchase)
      })
      var redemption_total = redemption_ratios.reduce(function(a, b) {
        return a + b;}, 0);
      console.log(redemption_total);
    }
    $('#investment_amount').change(function() {
      var amount = $(this).val();
      var total_return = amount * redemption_total / 100;
      $('#investment_amount_received').html('$' + total_return + '.00');
      $('#investment_amount_received_lower').html('<span>$' + total_return + '.00</span>');
      $('#amount_charged_to_user').html('$' + parseInt(amount) + '.00');
  
      $('.return_rate_period').each(function(index) {
        var amt = total_return * redemption_ratios[index] / redemption_total; 
        $(this).html('$' + amt + '.00');
      });
    });
});
if (!Array.prototype.reduce)
{
  Array.prototype.reduce = function(fun /*, initialValue */)
  {
    "use strict";

    if (this === void 0 || this === null)
      throw new TypeError();

    var t = Object(this);
    var len = t.length >>> 0;
    if (typeof fun !== "function")
      throw new TypeError();

    // no value to return if no initial value and an empty array
    if (len == 0 && arguments.length == 1)
      throw new TypeError();

    var k = 0;
    var accumulator;
    if (arguments.length >= 2)
    {
      accumulator = arguments[1];
    }
    else
    {
      do
      {
        if (k in t)
        {
          accumulator = t[k++];
          break;
        }

        // if array contains no values, no initial value to return
        if (++k >= len)
          throw new TypeError();
      }
      while (true);
    }

    while (k < len)
    {
      if (k in t)
        accumulator = fun.call(undefined, accumulator, t[k], k, t);
      k++;
    }

    return accumulator;
  };
}
/*

    if($('business_registration')){
      $('business_registration').addEvent('change', function(){
          if (this.get('value') == 1) {
              $('business_info').removeClass('hide');
          } else {
              $('business_info').addClass('hide');
          }
      });
    }


*/
