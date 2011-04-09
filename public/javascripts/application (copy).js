window.addEvent('domready', function(){
                
    $$('.new_window').addEvent('click', function(e){
        e.stop();
        var name = 'new_window'+ Math.random();
        window.open(this.get('href'));
    });

    if($('registration_form')) {
      var reg_form = new RequestController.Form($('registration_form'));
    
      $('registration_form').addEvent('submit', function(e) {
          if(Browser.Engine.trident) {
              window.scrollTo(0,0);
          }
      });
    }

    if($('business_registration')){
      $('business_registration').addEvent('change', function(){
          if (this.get('value') == 1) {
              $('business_info').removeClass('hide');
          } else {
              $('business_info').addClass('hide');
          }
      });
    }

    if($('terms_link')) {
      $('terms_link').addEvent('click', function(){
          window.open(
              '/terms',
              'popup',
              'width=650,height=700,scrollbars=yes,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'
          );
          return false;
      });
    }

    $('search').addEvent('focus', function() {
        if (this.get('value') == 'Find Merchant...') {
            this.set('value', '');
        }
    });

    $('search').addEvent('blur', function() {
        if (this.get('value') == '') {
            this.set('value', 'Find Merchant...');
        }
    });

    if($('region_listing')) {
      $('region_listing').addEvent('mouseover', function() {
        $$('ul li ul').setStyle('display', 'block');
        $$('ul li h2').setStyle('background', 'transparent url("/images/region-arrow.png") no-repeat 287px 10px');
      });
      $('region_listing').addEvent('mouseout', function() {
        $$('ul li ul').setStyle('display', 'none');
        $$('ul li h2').setStyle('background', 'transparent url("/images/region-arrow_closed.png") no-repeat 290px 6px');
      });
    }
    $('region_selection').addEvent('mouseover', function(e) {
      this.getElement('ul').setStyle('display', 'block');
      this.getElement('strong').setStyle('background', '#1a1b1b url(/images/images8/current_region_dropdown_arrow_down.png) no-repeat 95% center !important');
    });
    $('region_selection').addEvent('mouseout', function(e) {
      this.getElement('ul').setStyle('display', 'none');
      this.getElement('strong').setStyle('background', 'transparent url(/assets/images/images8/current_region_dropdown_arrow_left.png) no-repeat 95% center !important');
      this.getElement('strong a').setStyle('color', '#FD9C00');
    });
});
