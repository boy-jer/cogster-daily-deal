class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :community_id, :gender, :terms

  validates_acceptance_of :terms, :on => :create, :allow_nil => false
  validates_presence_of :first_name, :last_name
  belongs_to :community
  has_one :address, :as => :addressable
  accepts_nested_attributes_for :address
  has_many :purchases
  has_many :coupons, :through => :purchases
  has_many :projects, :through => :purchases, :uniq => true

  has_one :business
  #has_and_belongs_to_many :followers, :class_name => 'User'
  
  %w(admin merchant).each do |role|
    define_method "#{role}?" do
      self.role == role
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
    purchases.sum(:amount) / 2
  end

  def image
    "default_avatar.jpg"
  end

  def points
    purchases.sum(:amount)
  end

  def role
    super || 'user'
  end
end

