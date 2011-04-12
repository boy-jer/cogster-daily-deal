class PurchasesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :new
  before_filter :find_business, :find_community

  def create
    @purchase = current_user.purchases.build(params[:purchase])
    @purchase.customer_ip = request.remote_ip
    @purchase.type = params[:purchase][:type]
    @purchase.project = @business.current_project
    if @purchase.save
      redirect_to account_path, :notice => "Thank you for your purchase! You have ${@purchase.current_balance} in Cogster Cash available right now for use at @business.name."
    else
      @project = @purchase.project
      populate_form
      render :new
    end
  end

  def new
    @purchase = Purchase.new
    @project = @business.current_project
    populate_form
  end

  protected

  def find_business
    @business = Business.find(params[:business_id])
  end

  def populate_form
    @purchase.amount = @project.min_amount
    if current_user
      @purchase.first_name, @purchase.last_name = current_user.first_name, current_user.last_name
      @purchase.address = current_user.address
    end
  end
end
