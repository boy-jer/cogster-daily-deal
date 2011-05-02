class Admin::BusinessesController < ApplicationController

  before_filter :find_business, :only => [ :destroy, :edit, :update ]

  def create
    @merchant = User.new(params[:user])   
    @merchant.role = "Merchant"
    @merchant.terms = true
    if @merchant.save
      redirect_to admin_businesses_path, :notice => "#{@merchant.business.name} has been created"
    else
      set_options
      render :new
    end
  end

  def destroy
    @business.destroy
    redirect_to admin_businesses_path, :notice => "#{@business.name} has been deleted"
  end

  def edit
    set_options
  end

  def index
    @businesses = Business.includes(:merchant, :community, :current_project => :purchases)
  end

  def new
    @merchant = User.new
    @merchant.build_business(:address => Address.new)
    set_options
  end

  def show
    @business = Business.includes(:current_project).find(params[:id])
    render 'businesses/show'
  end

  def update
    if @business.update_attributes(params[:business])
      redirect_to admin_businesses_path, :notice => "Business updated"
    else
      set_options
      render :edit
    end
  end

  protected

    def find_business
      @business = Business.find(params[:id])
    end

end
