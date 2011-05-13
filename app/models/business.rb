class Business < ActiveRecord::Base
  belongs_to :merchant, :class_name => 'User'
  has_many :websites
  has_many :projects
  has_many :hours, :class_name => 'Hours', :order => 'day ASC'
  belongs_to :community
  has_one :address, :as => :addressable
  accepts_nested_attributes_for :websites, :hours, :reject_if => :all_blank,
                                                   :allow_destroy => true
  accepts_nested_attributes_for :address, :update_only => true, :reject_if => :all_blank
  belongs_to :business_option
  has_one :current_project, :class_name => 'Project', :conditions => { :active => true }
  delegate :supporters, :accepting_purchases?, :to => :current_project
  delegate :name, :to => :community, :prefix => true
  delegate :phone, :to => :address
  attr_accessor :deletion_explanation, :closed_days
  before_save :mark_websites_for_removal
  after_create :add_hours
  after_save :inform_owner, :merchantize_owner
  before_destroy :send_explanation
  validates_presence_of :name
  #validate :presence_of_community_and_merchant
  validates_uniqueness_of :name, :scope => :community_id
  validates_length_of :description, :maximum => 500

  mount_uploader :image, IconUploader

  def self.active
    where(['businesses.active = ?', true])
  end

  def self.category(cat)
    #find_all_by_business_option_id(cat)
    where(['business_option_id = ?', cat.to_i])
    #includes(:business_option).where(['business_options.category = ?', cat])
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
    Website::SOCIAL_MEDIA.each_with_index do |site, i|
      if existing_site = websites.detect{|w| w.url =~ /#{site}/ }
        existing_site.label = site
      else
        websites.insert(i, Website.new(:url => "http://www.#{site}.com"))
      end
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

    def inform_owner
      if merchant && !merchant.merchant?
        UserMailer.notify_of_activation(merchant.email).deliver
      end
    end

    def mark_websites_for_removal
      websites.each do |site|
        site.mark_for_destruction if site.url.blank?
      end
    end

    def merchantize_owner
      merchant.update_attribute(:role, 'merchant') if merchant
    end

    def presence_of_community_and_merchant
      unless community_id || community
        errors.add(:community_id, "must be present")
      end
        #what the fuck - there's no fucking way this should fucking break
        #with a goddamn factory. piece of shit software.
        #but it does, so I restrict this goddamn method to update
        #unless merchant_id || merchant
        #  errors.add(:merchant_id, "must be present")
        #end
    end

    def send_explanation
      if deletion_explanation.present?
        UserMailer.delete_business(merchant.email, deletion_explanation).deliver
      end
    end

end
