class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_one :business, :through => :project
  has_many :coupons, :order => :start_date, :dependent => :destroy do
    def for_week_and_project(date, _project)
      select do |c| 
        c.good_during_week_of?(date) && proxy_owner.project == _project
      end
    end
  end
  has_many :paypal_responses
  accepts_nested_attributes_for :user

  before_create :process_with_active_merchant
  after_create :create_coupons, :save_paypal_response, :increment_project_and_user, :send_email 

  attr_protected :customer_ip, :status, :error_message, :updated_at, :created_at
  validates_numericality_of :amount, :greater_than => 0
  #validates_acceptance_of :terms, :on => :create
  validate                  :validate_card, :on => :create
  delegate :redemption_schedule, :to => :project
  delegate :abbr_name, :cogster_id, :address, :to => :user

  attr_accessor :type, :expiration_year, :expiration_month, :card_number, :security_code, :first_name, :last_name, :redemption_start

  def self.check_for_expiring_coupons
    includes(:coupons, :user).each do |purchase|
      purchase.coupons.each{|coupon| coupon.check_for_status_change(purchase.user) } 
    end
  end

  def self.recent
    includes(:coupons).where(['coupons.expiration_date >= ?', Date.today - 30])
  end

  def cogster_cash
    coupons.sum(:amount)
  end

  def current_balance
    current_coupon.used? ? 0 : current_coupon.amount
  end

  def current_coupon
    if redemption_start
      coupons.first
    else
      coupons.detect{|c| c.current? } 
    end
  end

  protected

    def amount_in_pennies
      (amount * 100).to_i
    end

    def create_coupons
      start = redemption_start
      redemption_schedule.each do |period|
        coupon_amount = period[:percentage] * amount / 100
        coupons.create(:start_date => start, :amount => coupon_amount, :expiration_date => start + period[:duration] - 1)
        start = start + period[:duration] 
      end
    end

    def credit_card
      @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        :first_name         => first_name,
        :last_name          => last_name,
        :number             => card_number,
        :type               => type,
        :month              => expiration_month,
        :year               => expiration_year,
        :verification_value => security_code
      )
    end

    def increment_project_and_user
      project.increment_self_and_community!(amount)
      user.increment!(:earnings, coupons.sum(:amount) - amount)
    end

    def process_with_active_merchant
      response = GATEWAY.purchase(amount_in_pennies, credit_card, purchase_options) 
      if response.success?
        @response = paypal_responses.build(response_options(response))
      else
        errors.add(:base, response.message) 
        PaypalResponse.create(response_options(response))
        return false
      end
    end
         
    def purchase_options 
      {
        :ip => customer_ip,
        :billing_address => {
          :name =>  user.name,
          :line1 => address.line_1,
          :city  => address.city,
          :state => address.state,
          :country => address.country,
          :zip     => address.zip
      }}
    end

    def response_options(response)
      { 
        :amount => amount_in_pennies, 
        :action => 'purchase', 
        :response => response,
        :user_id => user_id,
        :project_id => project_id 
      }
    end

    def save_paypal_response
      true #@response.save
    end

    def send_email
      UserMailer.purchase_confirmation(self, current_coupon, user).deliver
    end

    def validate_card
      unless credit_card.valid? 
        credit_card.errors.full_messages.each do |message|
          errors.add(:base, message)
        end
      end
    end
end

