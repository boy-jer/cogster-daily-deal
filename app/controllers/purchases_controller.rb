class PurchasesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :new
  before_filter :find_business, :find_community

  def create
    @purchase = current_user.purchases.build(params[:purchase])
    @purchase.customer_ip = request.remote_ip
    @purchase.type = params[:purchase][:type]
    @purchase.project = @project
    if @purchase.save
      redirect_to account_path, :notice => "Thank you for your purchase! You have $#{sprintf "%0.2f", @purchase.current_balance} in Cogster Cash available right now for use at #{@business.name}."
    else
      @project = @purchase.project
      populate_form
      render :new
    end
  end

  def new
    @purchase = Purchase.new
    populate_form
  end

  protected

  def find_business
    @business = Business.find(params[:business_id])
    @project = @business.current_project
    if cannot? :purchase, @project
      redirect_to root_path(:protocol => 'http'), :notice => "That project is not available"
    end
  end

  def populate_form
    @purchase.amount ||= @project.min_amount
    if current_user
      @purchase.first_name, @purchase.last_name = current_user.first_name, current_user.last_name
    end
  end
end
