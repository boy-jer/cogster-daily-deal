class Community < ActiveRecord::Base
  has_many :businesses, :conditions => { :active => true },
                        :include => { :current_project => :project_option },
                        :order => "featured DESC, projects.goal = 0, 100 * projects.funded / projects.goal DESC, projects.funded DESC",
                        :dependent => :destroy
  has_many :inactive_businesses, :class_name => "Business",
                                 :conditions => { :active => false },
                                 :dependent => :destroy
  has_many :users, :dependent => :destroy
  after_create :send_request_feedback, :if => Proc.new{|c| c.community_request_id }
  attr_accessor :community_request_id, :request_message

  validates_presence_of :name
  validates_uniqueness_of :name

  def earnings_levels
    @earnings_levels ||= users.select(:earnings).map(&:earnings).uniq.sort
  end

  def handle
    if super.present?
      super
    elsif state.present?
      "#{name} #{state}".parameterize
    else
      name.parameterize
    end
  end

  def purchases
    businesses.map(&:purchases).flatten
  end

  def swag_rank(user)
    100.0 * earnings_levels.reverse.index(user.earnings) / earnings_levels.count
  end

  def to_param
    "#{id}-#{handle}"
  end

  protected

    def send_request_feedback
      community_request = CommunityRequest.find(community_request_id)
      community_request.destroy_with_positive_feedback(request_message)
    end
end

