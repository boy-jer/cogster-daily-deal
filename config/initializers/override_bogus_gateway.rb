module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    # Bogus Gateway
    class BogusGateway < Gateway
      #took these from TrustComerce documentation for cards
      GOOD_CARD ="5500000000000004" #valid master
      GOOD_CARD2='5411111111111115' #valid visa
      BAD_CARD  ='4012345678909'    #declined
      BAD_CARD2 ='5555444433332226'    #call in

      
      def authorize(money, creditcard, options = {})
        number = creditcard.is_a?(String) ? creditcard : creditcard.number
        case number
        when '1', GOOD_CARD, GOOD_CARD2
          Response.new(true, SUCCESS_MESSAGE, {:authorized_amount => money.to_s}, :test => true, :authorization => AUTHORIZATION )
        when '2', BAD_CARD, BAD_CARD2
          Response.new(false, FAILURE_MESSAGE, {:authorized_amount => money.to_s, :error => FAILURE_MESSAGE }, :test => true)
        else
          raise Error, ERROR_MESSAGE
        end      
      end
  
      def purchase(money, creditcard, options = {})
        number = creditcard.is_a?(String) ? creditcard : creditcard.number
        case number
        when '1', GOOD_CARD, GOOD_CARD2
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money.to_s, :transid => '3'}, :test => true)
        when '2', BAD_CARD, BAD_CARD2
          Response.new(false, FAILURE_MESSAGE, {:paid_amount => money.to_s, :error => FAILURE_MESSAGE },:test => true)
        else
          raise Error, ERROR_MESSAGE
        end
      end
 
      def credit(money, trans_id, options = {})
        case trans_id
        when '1'
          raise Error, CREDIT_ERROR_MESSAGE
        when '2'
          Response.new(false, FAILURE_MESSAGE, {:paid_amount => money.to_s, :error => FAILURE_MESSAGE }, :test => true)
        else
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money.to_s}, :test => true)
        end
      end
 
      def capture(money, trans_id, options = {})
        case trans_id
        when '1'
          raise Error, CAPTURE_ERROR_MESSAGE
        when '2'
          Response.new(false, FAILURE_MESSAGE, {:paid_amount => money.to_s, :error => FAILURE_MESSAGE }, :test => true)
        else
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money.to_s}, :test => true)
        end
      end

      def void(ident, options = {})
        case ident
        when '1'
          raise Error, VOID_ERROR_MESSAGE
        when '2'
          Response.new(false, FAILURE_MESSAGE, {:authorization => ident, :error => FAILURE_MESSAGE }, :test => true)
        else
          Response.new(true, SUCCESS_MESSAGE, {:authorization => ident}, :test => true)
        end
      end
      
      def store(creditcard, options = {})
        case creditcard.number
        when '1', GOOD_CARD, GOOD_CARD2
          Response.new(true, SUCCESS_MESSAGE, {:billingid => '1'}, :test => true, :authorization => AUTHORIZATION )
        when '2', BAD_CARD, BAD_CARD2
          Response.new(false, FAILURE_MESSAGE, {:billingid => nil, :error => FAILURE_MESSAGE }, :test => true)
        else
          raise Error, ERROR_MESSAGE + "was #{credit_card.number}"
        end              
      end
      
      def unstore(identification, options = {})
        case identification
        when '1'
          Response.new(true, SUCCESS_MESSAGE, {}, :test => true)
        when '2'
          Response.new(false, FAILURE_MESSAGE, {:error => FAILURE_MESSAGE },:test => true)
        else
          raise Error, UNSTORE_ERROR_MESSAGE
        end
      end
    end
  end
end
