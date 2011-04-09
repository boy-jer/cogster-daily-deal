class Project < ActiveRecord::Base
  belongs_to :project_option
  belongs_to :business
  validates_acceptance_of :terms

  has_many :purchases
  has_many :supporters, :through => :purchases, :source => :user, :uniq => true
  has_many :redemptions
  delegate :redemption_schedule, :redemption_period, :redemption_total, :to => :project_option

  def amount_funded
    purchases.sum('amount')
  end

  def min_amount
    super || 10
  end

  def percent_funded
    goal == 0 ? 0 : amount_funded / goal
  end

  def redemption_percentage(period)
    project_option.redemption_percentage(period) 
  end

end
