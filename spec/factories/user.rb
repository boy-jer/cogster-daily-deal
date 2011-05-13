Factory.define :user do |user|
  user.first_name            "Random"
  user.last_name             "Schlemiel"
  user.email                 "schlemiel@test.com"
  user.password              "password"
  user.password_confirmation "password"
  user.community { Community.find_by_name(Factory.attributes_for(:community)[:name]) || Factory(:community) }
  user.terms                 "1"
  user.role                  "cogster"
  user.confirmed_at          Time.now
end

Factory.define :merchant, :parent => :user do |merchant|
  merchant.first_name            "BJ"
  merchant.last_name             "Rib"
  merchant.email                 "tasty@selinsgrove.net"
  merchant.business              { Business.find_by_name(Factory.attributes_for(:business)[:business]) || Factory.build(:business) }
  merchant.role                  "merchant"
end

Factory.define :admin, :parent => :user do |admin|
  admin.first_name            "Steve"
  admin.last_name             "Bisbee"
  admin.email                 "real@person.com"
  admin.role                  "admin"
end
