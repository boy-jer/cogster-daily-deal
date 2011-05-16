class CouponsController < ApplicationController
  before_filter :find_business

  def edit
    @coupon = Coupon.includes(:purchase => :user).find(params[:id])
    @user = @coupon.user
  end

  def update
    @coupon = Coupon.find(params[:id])
    @coupon.toggle!(:used)
    redirect_to account_url, :notice => "#{@coupon.user.abbr_name}'s coupon has been redeemed.'"
  end

  protected

    def find_business
      @business = Business.find(params[:business_id])
    end
end
