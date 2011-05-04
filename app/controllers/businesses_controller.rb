class BusinessesController < ApplicationController
  before_filter :find_community
  skip_before_filter :authenticate_user!

  def index
    @businesses = Business.active.with_purchases.order(params[:sort])
    @businesses.reverse! if params[:sort] == 'created_at'
    @businesses.sort_by!{ |b| b.supporters.count } unless params[:sort]
    params[:filter] ||= "all" if params[:search].blank?
    filter_or_search
    if user_signed_in?
      @businesses, @other_businesses = @businesses.partition do |b|
        b.community_id == current_user.community_id
      end
    else
      @other_businesses = []
    end
    @merchant_types = BusinessOption.all
    render :search
  end

  def show
    @business = Business.includes(:current_project).find(params[:id])
  end

end
