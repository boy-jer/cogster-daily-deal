class Business < ActiveRecord::Base
  belongs_to :merchant, :class_name => 'User'
  has_many :websites
  belongs_to :community
  has_one :address, :as => :addressable
  accepts_nested_attributes_for :address
  has_many :projects
  belongs_to :business_option
  has_one :current_project, :class_name => 'Project', :conditions => { :active => true }
  delegate :supporters, :accepting_purchases?, :to => :current_project
  delegate :name, :to => :community, :prefix => true
  attr_accessor :deletion_explanation
  before_destroy :send_explanation

  def self.active
    where(['businesses.active = ?', true])
  end

  def self.category(cat)
    includes(:business_option).where(['business_options.category = ?', cat])
  end

  def self.with_purchases
    includes(:current_project => [:purchases, :supporters])
  end

  def current_project_with_ensure
    current_project_without_ensure || Project.new(:goal => 0)
  end
  alias_method_chain :current_project, :ensure

  def image
    'default.jpg'
  end

  def medium_image
    'default_medium.png'
  end

  def purchases
    projects.map(&:purchases).flatten
  end

  def to_param
    "#{id}-#{name.gsub(/'/,'').gsub(/\W+/, '-').gsub(/^-+/,'').gsub(/-+$/,'').downcase}"
  end

  protected

    def send_explanation
      if deletion_explanation.present?
        UserMailer.delete_business(merchant.email, deletion_explanation).deliver
      end
    end
end
