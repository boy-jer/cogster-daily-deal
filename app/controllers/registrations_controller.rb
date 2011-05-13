class RegistrationsController < Devise::RegistrationsController
  before_filter :set_options

  def new
    @user = User.new
    @user.build_business
  end
end
