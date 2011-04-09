class Coupon < ActiveRecord::Base
  belongs_to :purchase
  has_many :redemptions
end

