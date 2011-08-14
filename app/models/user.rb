class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :community_id, :gender, :terms,
                  :address_attributes, :business_attributes, :user_id

  validates_presence_of :first_name, :last_name
  belongs_to :community
  has_one :address, :as => :addressable
  has_one :business, :foreign_key => :merchant_id, :dependent => :destroy
  accepts_nested_attributes_for :address, :reject_if => :all_blank
  accepts_nested_attributes_for :business, 
    :reject_if => Proc.new{|attr| attr['name'].blank? && attr['description'].blank? }
  has_many :purchases
  has_many :coupons, :through => :purchases
  has_many :projects, :through => :purchases, :uniq => true
  before_create :set_cogster_id, :set_role
  before_validation :set_business_community

  %w(admin cogster merchant).each do |role|
    (class << self; self; end).instance_eval do
      define_method role do
        where(['role = ?', role])
      end
    end
  end

  %w(admin merchant cogster).each do |role|
    define_method "#{role}?" do
      self.role && self.role.downcase == role
    end
  end

  def self.unconfirmed
    where(['confirmed_at IS NULL'])
  end

  def abbr_name
    "#{first_name} #{last_name[0]}"
  end

  def address_with_ensure
    address_without_ensure || Address.new
  end
  alias_method_chain :address, :ensure

  def image
    "default_avatar.jpg"
  end

  def made_purchase_for?(project)
    purchases_of(project) > 0
  end

  def may_make_purchase_for?(project)
    project.accepting_purchases? &&
    purchases_of(project) < project.amount
  end

  def name
    "#{first_name} #{last_name}"
  end

  def owns?(business)
    id == business.merchant_id
  end

  def points
    purchases.sum(:amount) * 50
  end

  def purchases_of(project)
    purchases.where(['project_id = ?', project.id]).sum(:amount)
  end

  def set_terms_and_confirmed_and_role(role)
    skip_confirmation!
    self.role = role
  end

  def sole_purchaser_of(project)
    purchases_of(project) == project.funded
  end

  def swag_rank
    community.swag_rank(self)
  end

  protected

    def has_no_password?
      encrypted_password.blank?
    end
   
    def password_required?
      !persisted? || !password.blank? || !password_confirmation.blank?
    end

    def set_business_community
      if business && business.community_id.nil?
        business.community_id = community_id
      end
    end

    def set_cogster_id
      self.cogster_id = SecureRandom.hex(5)[0..8].upcase
    end
     
    def set_role
      self.role ||= 'cogster'
    end
end
