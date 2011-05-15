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

end
