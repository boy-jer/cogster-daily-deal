class Admin::BusinessOptionsController < ApplicationController
  before_filter :find_option, :only => [ :destroy, :edit, :show, :update ]

  def create
    @business_option = BusinessOption.new(params[:business_option])
    if @business_option.save
      redirect_to admin_business_options_url
    else
      render :new
    end
  end

  def destroy
    @business_option.destroy
    redirect_to admin_business_options_url
  end

  def edit

  end

  def index
    @business_options = BusinessOption.all
  end

  def new
    @business_option = BusinessOption.new
  end

  def show

  end

  def update
    if @business_option.update_attributes(params[:business_option])
      redirect_to admin_business_options_url
    else
      render :edit
    end
  end

  protected

    def find_option
      @business_option = BusinessOption.find(params[:id])
    end
end
