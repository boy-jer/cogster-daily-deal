class BusinessesController < ApplicationController
  before_filter :find_community
  skip_before_filter :authenticate_user!

  def edit
    @business = current_user.business
    set_options_and_websites
  end

  def edit_logo
    @business = current_user.business
  end

  def index
    @businesses = Business.active.with_purchases.community_ordered(current_user, params[:sort]).category(params[:filter]).search(params[:search]).paginate(:per_page => 10, :page => params[:page])
    @merchant_types = BusinessOption.all
    render :search
  end

  def show
    @business = Business.includes(:current_project).find(params[:id])
  end

  def update
    @business = current_user.business
    if @business.update_attributes(params[:business])
      redirect_to account_path, :notice => "Business profile updated"
    else
      set_options_and_websites
      render :edit
    end
  end

  protected

    def set_options_and_websites
      set_options
      @business.ensure_websites_present 
    end
end
