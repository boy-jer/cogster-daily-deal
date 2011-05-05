class UserMailer < ActionMailer::Base
  default :from => "alltheguysandgals@cogster.com"

  def accept_community_request(request, msg)
    @msg = msg
    mail(:to => request.email, :subject => "Good news! Your community is now in Cogster!")
  end

  def delete_business(addr, msg)
    @msg = msg
    mail(:to => addr, :subject => "The business you suggested for Cogster isn't a good fit")
  end

  def deny_community_request(request)
    @community = request.zip_code
    mail(:to => request.email, :subject => "The community you suggested for Cogster isn't a good fit")
  end

  def expiration_warning(coupon, user)
    @amount = coupon.remainder
    set_common_variables(coupon, user)
    mail(:to => user.email, :subject => "Your Cogster Cash is about to expire!")
  end

  def new_coupon(coupon, user)
    set_common_variables(coupon, user)
    @amount = coupon.initial_amount
    mail(:to => user.email, :subject => "You can use more Cogster Cash starting today!")
  end

  def purchase_confirmation(purchase, coupon, user)
    set_common_variables(coupon, user)
    @amount = purchase.amount
    @cogster_cash = purchase.cogster_cash

    mail(:to => user.email, :subject => "Thank you for your Cogster purchase")
  end

  protected

  def set_common_variables(coupon, user)
    @name = user.first_name
    @business = coupon.business.name
    @expiration = coupon.expiration_date.strftime("%B %d")
  end
end
