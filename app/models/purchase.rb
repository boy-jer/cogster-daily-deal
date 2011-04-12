class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_one :business, :through => :project
  has_many :coupons
  has_many :redemptions, :through => :coupons
  has_one :address
  accepts_nested_attributes_for :address

  after_create :create_coupons, :send_email

  attr_protected :customer_ip, :status, :error_message, :updated_at, :created_at
  validates_inclusion_of :status, :in => %w(open processed closed failed), :allow_blank => true
  validates_numericality_of :amount, :greater_than => 0
  validates_acceptance_of :terms, :on => :create
  validate                  :validate_card, :on => :create

  attr_accessor :type, :expiration_year, :expiration_month, :card_number, :security_code, :first_name, :last_name

  def current_balance
    current_coupon.remainder
  end

  def current_coupon
    coupons.detect do |c| 
      (c.start_date..c.expiration_date).member?(Date.today) 
    end
  end

  protected

    def amount_in_pennies
      (amount * 100).to_i
    end

    def create_coupons
      schedule = project.redemption_schedule
      start = Date.today
      schedule.each do |period|
        coupon_amount = period[:percentage] * amount / 100
        coupons.create(:start_date => start, :initial_amount => coupon_amount, :expiration_date => start + period[:duration], :remainder => coupon_amount)
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

    end

    def validate_card
      if Rails.env == 'production'
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

