class Coupon < ActiveRecord::Base
  belongs_to :purchase
  delegate :user, :business, :to => :purchase

  def check_for_status_change(user)
    check_for_expiration(user)
    check_for_newly_current(user)
  end

  def current?
    !expired? && !future? && !used?
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

    def check_for_expiration(user)
      if current? && expiration_date == Date.today + 2
        UserMailer.expiration_warning(self, user).deliver
      end
    end

    def check_for_newly_current(user)
      if start_date == Date.today
        UserMailer.new_coupon(self, user).deliver
      end
    end

end
