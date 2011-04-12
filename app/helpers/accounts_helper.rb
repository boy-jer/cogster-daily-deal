module AccountsHelper

  def cash_link(coupon)
    if coupon.expired?
      'Expired'
    elsif coupon.future?
      'Future'
    else
      link_to "Print Cash", cash_path(coupon), :class => "button"
    end
  end

  def expiration_status(coupon)
    "#{cycle('odd', 'even')} #{coupon.expired?? 'expired' : !coupon.future?? 'active' : ''}"  
  end
end
