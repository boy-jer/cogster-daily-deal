module ProjectsHelper

  def status_for(coupon)
    if coupon.used?
      'Processed'
    else
      number_to_currency(coupon.amount)
    end
  end
end
