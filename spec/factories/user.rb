Factory.define :user do |user|
  user.first_name            "Random"
  user.last_name             "Schlemiel"
  user.email                 "schlemiel@test.com"
  user.password              "password"
  user.password_confirmation "password"
  user.association           :community, :factory => :community
  user.terms                 "1"
  user.role                  "cogster"
end

Factory.define :merchant, :parent => :user do |merchant|
  merchant.first_name            "BJ"
  merchant.last_name             "Rib"
  merchant.email                 "tasty@selinsgrove.net"
  merchant.password              "password"
  merchant.password_confirmation "password"
  merchant.association           :business, :factory => :business
  merchant.community             {|b| b.community }
  merchant.role                  "merchant"
  merchant.terms                 "1"
end

Factory.define :admin, :parent => :user do |admin|
  admin.first_name            "Steve"
  admin.last_name             "Bisbee"
  admin.email                 "real@person.com"
  admin.password              "password"
  admin.password_confirmation "password"
  admin.association           :community, :factory => :community
  admin.role                  "admin"
  admin.terms                 "1"
end
