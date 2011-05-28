module Admin
  class BaseController < ApplicationController
    before_filter :verify_admin

    protected

      def verify_admin
        redirect_to root_url unless user_signed_in? && current_user.admin?
      end
  end
  
end
