class RedemptionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @coupon = Coupon.find(params[:id])
    @redemption = @coupon.redemptions.new(params[:redemption])
    if @redemption.save
      redirect_to account_url
    else
      render :show
    end
  end

  def show
    @business = Business.find(params[:business_id])
    @coupon = Coupon.includes(:purchase => :user).find(params[:id])
    #redirect_to root_url unless @coupon.purchase.business_id == @business.id
    @user = @coupon.purchase.user
    @redemption = @coupon.redemptions.new
  end

end
