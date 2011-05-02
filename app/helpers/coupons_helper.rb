module CouponsHelper

  def redemption_date_range
    endpoint = [@coupon.expiration_date, Date.today].min
    (@coupon.start_date..endpoint)
  end

end
