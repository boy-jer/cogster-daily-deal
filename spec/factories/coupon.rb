Factory.define :coupon do |coupon|
  coupon.start_date Date.today - 3
  coupon.expiration_date Date.today + 3
  coupon.amount 20
end
