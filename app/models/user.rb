class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :community_id, :gender, :terms,
                  :address_attributes, :business_attributes

  validates_acceptance_of :terms, :on => :create, :allow_nil => false
  validates_presence_of :first_name, :last_name
  belongs_to :community
  has_one :address, :as => :addressable
  has_one :business, :foreign_key => :merchant_id
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :business, 
    :reject_if => Proc.new{|attr| attr['name'].blank? && attr['description'].blank? }
  has_many :purchases
  has_many :coupons, :through => :purchases
  has_many :projects, :through => :purchases, :uniq => true
  before_create :set_cogster_id

  %w(admin cogster merchant).each do |role|
    (class << self; self; end).instance_eval do
      define_method role do
        where(['role = ?', role])
      end
    end
  end

  %w(admin merchant).each do |role|
    define_method "#{role}?" do
      self.role.downcase == role
    end
  end

  def abbr_name
    "#{first_name} #{last_name[0]}"
  end

  def address_with_ensure
    address_without_ensure || Address.new
  end
  alias_method_chain :address, :ensure

  def earnings
    coupons.sum(:initial_amount) - purchases.sum(:amount) 
  end

  def image
    "default_avatar.jpg"
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

  def role
    super || 'cogster'
  end

  def swag_rank
    community.swag_rank(self)
  end

  protected

    def set_cogster_id
      self.cogster_id = SecureRandom.hex(5)[0..8].upcase
    end
end
