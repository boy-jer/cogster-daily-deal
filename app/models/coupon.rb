class Coupon < ActiveRecord::Base
  belongs_to :purchase
  has_many :redemptions
  before_create :set_remainder
  after_update :create_redemption
  before_update :calculate_remainder
  validates_numericality_of :remainder, 
                            :on => :update, :greater_than_or_equal_to => 0
  attr_accessor :redemption_date, :redemption_amount
  delegate :user, :business, :to => :purchase

  def check_for_status_change(user)
    check_for_expiration(user)
    check_for_newly_current(user)
  end

  def current?
    !expired? && !future?
  end

  def expired?
    Date.today > expiration_date
  end

  def future?
    Date.today < start_date
  end

  def good_during_week_of?(day)
    expiration_date >= day && start_date <= day + 6
  end

  protected

    def calculate_remainder
      self.remainder -= redemption_amount.to_f
    end

    def check_for_expiration(user)
      if current? && remainder > 0 && expiration_date == Date.today + 2
        UserMailer.expiration_warning(self, user).deliver
      end
    end

    def check_for_newly_current(user)
      if start_date == Date.today
        UserMailer.new_coupon(self, user).deliver
      end
    end

    def create_redemption
      amount = remainder_change.first - remainder_change.last
      redemptions.create(:date => redemption_date, :amount => amount)
    end

    def set_remainder
      self.remainder = initial_amount
    end
end
