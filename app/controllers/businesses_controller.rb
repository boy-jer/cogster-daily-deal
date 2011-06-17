class BusinessesController < ApplicationController
  before_filter :find_community
  before_filter :find_merchant_business, :only => [:edit, :edit_logo, :update]
  skip_before_filter :authenticate_user!

  def edit
    set_options
    @business.website ||= Website.new
  end

  def edit_logo
  end

  def index
    @businesses = Business.active.with_purchases.community_ordered(current_user, params[:sort]).category(params[:filter]).search(params[:search]).paginate(:per_page => 10, :page => params[:page])
    @merchant_types = BusinessOption.all
    render :search
  end

  def show
    @business = @community.businesses.includes(:current_project, :hours, :address, :website).find(params[:id])
    if cannot? :read, @business
      redirect_to root_path, :notice => "Sorry, that business is not currently active."
    end
  end

  def update
    if @business.update_attributes(params[:business])
      redirect_to account_path, :notice => "Business profile updated"
    else
      set_options
      @business.website ||= Website.new
      render :edit
    end
  end

  protected

    def find_merchant_business
      @business = current_user.business
    end
end
