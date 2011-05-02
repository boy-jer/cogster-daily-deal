class Project < ActiveRecord::Base
  belongs_to :project_option
  belongs_to :business
  validates_acceptance_of :terms

  has_many :purchases
  has_many :supporters, :through => :purchases, :source => :user, :uniq => true
  has_many :redemptions
  delegate :redemption_schedule, :redemption_period, :redemption_total, :to => :project_option

  def accepting_purchases?
    amount_funded < goal
  end

  def amount_funded
    purchases.sum('amount')
  end

  def max_for(user = nil)
    [(max_amount - (user ? user.purchases_of(self) : 0)), goal - amount_funded].min
  end

  def min_amount
    super || 10
  end

  def min_redemption_amount(period)
    min_amount * redemption_percentage(period)
  end

  def percent_funded
    (goal.nil? || goal == 0) ? 0 : (100 * amount_funded / goal).to_i
  end

  def redemption_percentage(period)
    project_option.redemption_percentage(period) 
  end

  def steps_for(user)
    min_amount.step(max_for(user), 10)
  end

end
