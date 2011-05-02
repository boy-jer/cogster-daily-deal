Factory.define :coupon do |coupon|
  coupon.start_date Date.today - 3
  coupon.expiration_date Date.today + 3
  coupon.initial_amount 20
  coupon.remainder 20
end
