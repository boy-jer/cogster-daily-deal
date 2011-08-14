class Project < ActiveRecord::Base
  belongs_to :project_option
  belongs_to :business
  validates_acceptance_of :terms

  PURCHASE_AMOUNT_OPTIONS = [10, 15, 20, 25, 30, 50, 75, 100]

  has_many :purchases do
    def sorted
      sort_by{|p| [p.abbr_name, p.created_at] }
    end
  end
  has_many :supporters, :through => :purchases, :source => :user, :uniq => true
  has_many :redemptions
  delegate :redemption_schedule, :redemption_period, :redemption_total, :to => :project_option
  delegate :community, :to => :business
  validates_presence_of :business_id, :name, :amount, :goal, :project_option_id
  validates_length_of :reason, :maximum => 500
  validates_numericality_of :goal, :greater_than => 0

  def accepting_purchases?
    funded < goal
  end

  def max_for(user = nil)
    [(amount - (user ? user.purchases_of(self) : 0)), goal - funded].min
  end

  def max_redemption
    amount * redemption_total
  end

  def min_redemption_amount(period)
    amount * redemption_percentage(period)
  end

  def no_goal?
    goal.nil? || goal == 0 
  end

  def percent_funded
    no_goal? ? 0 : (100 * funded / goal).to_i
  end

  def percent_funded_by(user = nil)
    (no_goal? || user.nil?) ? 0 : (100 * user.purchases_of(self) / goal).to_i
  end

  def percent_funded_less(user = nil)
    percent_funded - percent_funded_by(user)
  end

  def purchase_start_date
    community.event_start_date
  end

  def purchase_completion_date
    community.event_completion_date
  end

  def redemption_percentage(period)
    project_option.redemption_percentage(period) 
  end

  def top_supporters
    supporters.map{|s| [s, purchases.select{|p| p.user_id == s.id }.sum(&:amount)]}.sort_by{|arr| [-1 * arr[1], arr[0].created_at] }[0..4].map(&:first)
  end

  protected

    def increment_community_impact!
      community.increment!(:impact, 3 * (funded - funded_was))
    end

    def increment_self_and_community!(amount)
      self.funded += amount
      increment_community_impact!
      save!
    end
end
