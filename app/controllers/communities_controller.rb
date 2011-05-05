class CommunitiesController < ApplicationController
  skip_before_filter :authenticate_user!

  def show
    @community = Community.includes(:businesses => { :current_project => :purchases }).find(params[:id])
    @communities = Community.all.reject{|c| c == @community }
    @businesses = @community.businesses
    filter_or_search
    @businesses.sort_by!(&params[:sort].to_sym) if params[:sort]
    @businesses.reverse! if params[:sort] == 'created_at'
    @businesses.sort_by!{|x| x.featured?? 0 : 1 }
    @other_businesses = []
    @cogs = @community.users.sort_by{|u| [u.earnings, u.created_at]}
    @merchant_types = @businesses.map(&:business_option).uniq
  end
end
