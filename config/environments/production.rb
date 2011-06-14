Cogster::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  # config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  config.action_mailer.default_url_options = { :host => 'cogster.littleredbrick.net' }
  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :production #remember to switch to test for sandbox
    ActiveMerchant::Billing::LinkpointGateway.pem_file = File.read(File.dirname(__FILE__) + '/../1909010267.pem')
    ::GATEWAY = ActiveMerchant::Billing::LinkpointGateway.new(
    :login => '1234567890')
    #::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
    #  :login => '2v76SvvM5b',
    #  :password => '46SkhMf927AyXt2L',
    #  :test => true
    #)
    #::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
      #credentials for my sandbox, put on server for testing
      # :login => 'brian_1305061324_biz_api1.gmail.com',
      # :password => '1305061338',
      # :signature => 'AhMj-Qk-95Ugtw2EUfTt3VrLYoonA2s75xJwuw.C5dma90wDmlt9S75u'

      #below are credentials for steve's real account
       #when this is set, remember to change mode to production
    #  :login => 'chris_api1.cogster.com',#from api key
    #  :password => '4929RCZXD247X5FQ', #ditto
    #  :signature =>'ARnr1B7zyTW-GnPsQyeq1OlHOUOpAaYyHrRwiti2liIHXowz9rTCR9uQ'
#    )
  end
end
