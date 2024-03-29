class ApplicationController < ActionController::Base
  protect_from_forgery
  clear_helpers

  before_filter :authenticate_user!, :store_location

  protected

    def after_sign_in_path_for(resource)
      if stored_location_for(:user)
        stored_location_for(:user)
      elsif resource.sign_in_count == 1 && resource.cogster?
        community_path(resource.community)
      else
        account_path
      end
    end

    def find_community
      @community = 
      if @business
        @business.community
      elsif params[:community_id]
        Community.find(params[:community_id])
      elsif current_user
        current_user.community
      else
        Community.first 
      end
      @communities = Community.all.reject{|c| c == @community }
    end

    def relocation_location
      request.fullpath == root_path ? account_path : request.fullpath
    end

    def set_options
      @options = Community.all.map{|c| [c.name, c.id] }
      @business_options = BusinessOption.all.map{|b| [b.category, b.id] }
    end

    def store_location
      session[:user_return_to] = relocation_location if should_store_location?
    end

    def should_store_location?
      request.get? && [login_path, register_path].exclude?(request.fullpath) && !user_signed_in?
    end

    def stored_location_for(resource_or_scope)
      default = super
      default =~ /#{Regexp.quote(user_confirmation_path(:confirmation_token => ''))}/ ? nil : default
    end
end
