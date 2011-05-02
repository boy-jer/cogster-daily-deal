class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_one :business, :through => :project
  has_many :coupons do
    def for_week_and_project(date, _project)
      select do |c| 
        c.good_during_week_of?(date) && proxy_owner.project == _project
      end
    end
  end
  has_many :redemptions, :through => :coupons
  has_one :address
  accepts_nested_attributes_for :address

  after_create :create_coupons, :send_email

  attr_protected :customer_ip, :status, :error_message, :updated_at, :created_at
  validates_inclusion_of :status, :in => %w(open processed closed failed), :allow_blank => true
  validates_numericality_of :amount, :greater_than => 0
  validates_acceptance_of :terms, :on => :create
  validate                  :validate_card, :on => :create
  delegate :redemption_schedule, :to => :project

  attr_accessor :type, :expiration_year, :expiration_month, :card_number, :security_code, :first_name, :last_name

  def self.check_for_expiring_coupons
    includes(:coupons).each do |purchase|
      purchase.coupons.each{|coupon| coupon.check_for_status_change(purchase.user) } 
    end
  end

  def cogster_cash
    coupons.sum(:initial_amount)
  end

  def current_balance
    current_coupon.remainder
  end

  def current_coupon
    coupons.detect{|c| c.current? } 
  end

  protected

    def amount_in_pennies
      (amount * 100).to_i
    end

    def create_coupons
      start = Date.today
      redemption_schedule.each do |period|
        coupon_amount = period[:percentage] * amount / 100
        coupons.create(:start_date => start, :initial_amount => coupon_amount, :expiration_date => start + period[:duration] - 1)
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

    #railscasts has a method like this called in controller
    #conditional on save working, so the #valid? isn't needed
    #also the response (of the method) is simply to set :updated_at for a cart
    #and to return response.success? as boolean
    def process_with_active_merchant
      if credit_card.valid?                  
        response = GATEWAY.purchase(amount_in_pennies, credit_card, purchase_options) 
        #transactions.create!(:action => "process_with_active_merchant", :amount => amount_in_pennies, :response => response)
        if response.success?
          "Charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"
        else
          raise StandardError, response.message
        end
      else
        credit_card.errors.full_messages
      end
    end
         
    def purchase_options #need to find out how to structure addr
      {
        :ip => customer_ip,
        :billing_address => {
          :name => 'name',
          :line1=> 'addr'
      }}
    end

    def send_email
      UserMailer.purchase_confirmation(self, current_coupon, user).deliver
    end

    def validate_card
      if false #Rails.env == 'production'
        unless credit_card.valid?
          credit_card.errors.full_messages.each do |message|
            errors.add(:base, message)
          end
        end
      else
        errors.add(:type, 'must be MasterCard for demo') unless type == 'master'
      end
    end
end

