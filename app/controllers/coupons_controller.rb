class CouponsController < ApplicationController
  before_filter :find_business

  def edit
    @coupon = Coupon.includes(:redemptions, :purchase => :user).find(params[:id])
    @user = @coupon.user
  end

  def update
    @coupon = Coupon.find(params[:id])
    if @coupon.update_attributes(params[:coupon])
      redirect_to account_url
    else
      render :edit
    end
  end

  protected

    def find_business
      @business = Business.find(params[:business_id])
    end
end
