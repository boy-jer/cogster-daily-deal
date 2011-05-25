class CommunitiesController < ApplicationController
  skip_before_filter :authenticate_user!

  def show
    @community = Community.includes(:businesses => [ :business_option, :current_project => :purchases ], :users => :purchases).find(params[:id])
    @communities = Community.where(['id != ?', @community])
    @businesses = @community.businesses.ordered(params[:sort]).category(params[:filter]).paginate(:per_page => 10, :page => params[:page])
    @cogs = @community.users.sort_by{|u| [u.earnings, u.created_at]}[0..4]
    @merchant_types = @businesses.map(&:business_option).compact.uniq
  end

end
