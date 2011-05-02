class RegistrationsController < Devise::RegistrationsController
  before_filter :set_options

end
