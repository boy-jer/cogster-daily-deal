Cogster::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # Don't care if the mailer can't send
  config.action_mailer.delivery_method = :test
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::LinkpointGateway.pem_file = File.read(File.dirname(__FILE__) + '/../1909010267.pem')
    ::GATEWAY = ActiveMerchant::Billing::LinkpointGateway.new(
    :login => '1909010267')
    #::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
    #  :login => '2v76SvvM5b',
    #  :password => '46SkhMf927AyXt2L',
    #  :test => true
    #)
#    ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
#       :login => 'brian_1305061324_biz_api1.gmail.com',
#       :password => '1305061338',
#       :signature => 'AhMj-Qk-95Ugtw2EUfTt3VrLYoonA2s75xJwuw.C5dma90wDmlt9S75u'
       #the below credentials were from old dev team sandbox
#      :login => 'chris_1248755694_biz_api1.cogster.com',#from api key
#      :password =>'1248755704', #ditto, and should be a signature I think
#      :signature =>'AEiYAq53vzWqRq6Q4s61u4YUD0KTABvBijoyM8fqFXnG.fEkqmaXmc-S' 
    #)
  end
end

