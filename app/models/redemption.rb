class Redemption < ActiveRecord::Base
  belongs_to :coupon
  belongs_to :project
end
