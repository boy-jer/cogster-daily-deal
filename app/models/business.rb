class Business < ActiveRecord::Base
  belongs_to :merchant, :class_name => 'User'
  has_one :website, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :hours, :class_name => 'Hours', :order => 'day ASC', :dependent => :destroy
  belongs_to :community
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :website, :hours, :reject_if => :all_blank,
                                                   :allow_destroy => true
  accepts_nested_attributes_for :address, :reject_if => :nothing_but_country
  belongs_to :business_option
  has_one :current_project, :class_name => 'Project', :conditions => { :active => true }
  delegate :supporters, :top_supporters, :accepting_purchases?, :to => :current_project
  delegate :name, :to => :community, :prefix => true
  delegate :phone, :to => :address
  attr_accessor :deletion_explanation, :closed_days
  before_save :mark_website_for_removal
  after_create :add_hours
  #after_save :inform_owner, :merchantize_owner
  before_destroy :send_explanation
  after_destroy :unmerchantize_owner
  validates_presence_of :name
  #validate :presence_of_community_and_merchant
  validates_uniqueness_of :name, :scope => :community_id
  validates_length_of :description, :maximum => 500

  mount_uploader :image, IconUploader

  def self.active
    where(['businesses.active = ?', true])
  end

  def self.category(cat)
    if cat.nil? || cat == 'all'
      where('')
    else
      where(['business_option_id = ?', cat.to_i])
    end
  end

  def self.community_ordered(user, sort_order)
    if user
      order("community_id = #{user.community_id} DESC").ordered(sort_order, :order)
    else
      ordered(sort_order, :order)
    end
  end

  def self.ordered(sort_order, order = :reorder)
    if sort_order == 'name'
      send(order, 'businesses.name ASC')
    elsif sort_order == 'created_at'
      send(order, 'businesses.created_at DESC')
    else
      where('')
    end
  end

  def self.search(query)
    if query
      where(["UPPER(businesses.name) LIKE ?", "%#{query.upcase}%"])
    else
      where('')
    end
  end

  def self.with_purchases
    includes(:current_project => { :purchases => :user })
  end

  def closed_on?(n)
    hours[n].closed? 
  end

  def current_project_with_ensure
    current_project_without_ensure || Project.new(:goal => 0, :funded => 0)
  end
  alias_method_chain :current_project, :ensure

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
      if active && merchant && !merchant.merchant?
        UserMailer.notify_of_activation(merchant.email).deliver
      end
    end

    def mark_website_for_removal
      website.mark_for_destruction if website && website.url.blank?
    end

    def merchantize_owner
      merchant.update_attribute(:role, 'merchant') if merchant
    end

    def nothing_but_country(attributes)
      attributes.all?{|pair| pair[0] == 'country' || pair[1].blank? }
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

    def unmerchantize_owner
      merchant.update_attribute(:role, 'cogster')
    end

end
