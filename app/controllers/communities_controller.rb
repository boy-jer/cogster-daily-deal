class CommunitiesController < ApplicationController
  skip_before_filter :authenticate_user!

  def show
    @community = Community.includes(:businesses => { :current_project => :purchases }).find(params[:id])
    @communities = Community.all.reject{|c| c == @community }
    @businesses = @community.businesses
    filter_or_search
    @businesses.sort_by!(&params[:sort].to_sym) if params[:sort]
    @other_businesses = []
    @cogs = @community.users.sort_by(&:earnings)
  end
end
