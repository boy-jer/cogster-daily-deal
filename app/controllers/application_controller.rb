class ApplicationController < ActionController::Base
  protect_from_forgery
  clear_helpers

  before_filter :authenticate_user!, :store_location

  protected

    def filter_or_search
      if params[:search]
        @businesses = @businesses.where(["UPPER(businesses.name) LIKE ?", "%#{params[:search].upcase}%"])
      elsif params[:filter].present? && params[:filter] != "all"
        @businesses = @businesses.category(params[:filter])
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
end
