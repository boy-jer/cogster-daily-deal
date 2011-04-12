class ApplicationController < ActionController::Base
  protect_from_forgery
  clear_helpers

  before_filter :authenticate_user!

  protected

    def find_community
      @community = current_user ? current_user.community : Community.first
      @communities = Community.all.reject{|c| c == @community }
    end
end
