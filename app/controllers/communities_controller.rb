class CommunitiesController < ApplicationController
  skip_before_filter :authenticate_user!

  def show
    @community = Community.find(params[:id])
    @communities = Community.where(['id != ?', @community])
    @businesses = @community.businesses.ordered(params[:sort]).category(params[:filter]).paginate(:per_page => 10, :page => params[:page])
    @cogs = @community.users.order('earnings DESC', :created_at).limit(5)
    @merchant_types = BusinessOption.find(@businesses.map(&:business_option_id)).compact.uniq
  end

end
