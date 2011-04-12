class Coupon < ActiveRecord::Base
  belongs_to :purchase
  has_many :redemptions

  def expired?
    Date.today > expiration_date
  end

  def future?
    Date.today < start_date
  end
end

