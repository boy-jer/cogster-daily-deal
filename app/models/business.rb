class Business < ActiveRecord::Base
  belongs_to :merchant, :class_name => 'User'
  has_many :websites
  has_many :projects
  has_many :hours, :class_name => 'Hours', :order => 'day ASC'
  belongs_to :community
  has_one :address, :as => :addressable
  accepts_nested_attributes_for :websites, :hours, :reject_if => :all_blank
  accepts_nested_attributes_for :address, :update_only => true
  belongs_to :business_option
  has_one :current_project, :class_name => 'Project', :conditions => { :active => true }
  delegate :supporters, :accepting_purchases?, :to => :current_project
  delegate :name, :to => :community, :prefix => true
  delegate :phone, :to => :address
  attr_accessor :deletion_explanation, :closed_days
  after_create :add_hours
  before_destroy :send_explanation
  validates_presence_of :name, :community_id
  validates_uniqueness_of :name, :scope => :community_id

  mount_uploader :image, IconUploader

  def self.active
    where(['businesses.active = ?', true])
  end

  def self.category(cat)
    includes(:business_option).where(['business_options.category = ?', cat])
  end

  def self.with_purchases
    includes(:current_project => [:purchases, :supporters])
  end

  def closed_on?(n)
    hours[n].closed? && !hours.all?{|day| day.closed? }
  end

  def current_project_with_ensure
    current_project_without_ensure || Project.new(:goal => 0)
  end
  alias_method_chain :current_project, :ensure

  def ensure_websites_present
    until websites.length >= 4 do
      websites.build
    end
  end

  def medium_image
    image_url(:thumb) || 'default_medium.png'
  end

  def purchases
    projects.map(&:purchases).flatten
  end

  def to_param
    "#{id}-#{name.gsub(/'/,'').gsub(/\W+/, '-').gsub(/^-+/,'').gsub(/-+$/,'').downcase}"
  end

  protected

    def add_hours
      0.upto(6){|day| hours.create(:day => day) }
    end

    def send_explanation
      if deletion_explanation.present?
        UserMailer.delete_business(merchant.email, deletion_explanation).deliver
      end
    end
end
