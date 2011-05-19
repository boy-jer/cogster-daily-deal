class Admin::UsersController < ApplicationController
  before_filter :find_user, :except => [ :create, :index, :new ]
  before_filter :set_options, :only => [:new, :edit]

  def create
    @user = User.new(params[:user])
    @user.set_terms_and_confirmed_and_role(params[:user][:role])
    @user.set_business_community
    if @user.save
      redirect_to admin_users_path(:type => @user.role), :notice => "An account for #{@user.name} has been created"
    else
      set_options
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path(:type => @user.role), :notice => "#{@user.name}'s account has been deleted'"
  end

  def edit

  end

  def index
    if params[:type] == 'merchants'
      @merchants = User.merchant.includes(:business, :community).order('businesses.active').paginate(:per_page => 10, :page => params[:page])
      render :merchants
    elsif params[:type] == 'admin'
      @admin = User.admin.paginate(:per_page => 10, :page => params[:page])
      render :admin
    elsif params[:type] == 'unconfirmed'
      @users = User.unconfirmed.includes(:community).paginate(:per_page => 10, :page => params[:page])
      render :unconfirmed
    else
      @cogsters = User.cogster.includes(:community).paginate(:per_page => 10, :page => params[:page])
    end
  end

  def new
    @user = User.new 
    @business = @user.build_business
  end

  def show

  end

  def update
    if params[:confirm]
      @user.confirm!
      redirect_to admin_users_path(:type => 'unconfirmed'), :notice => "#{@user.name} has been confirmed"
    elsif @user.update_attributes(params[:user])
      @user.role = params[:user][:role]
      @user.save
      redirect_to admin_users_path(:type => @user.role), :notice => "#{@user.name} has been updated"
    else
      set_options
      render :edit
    end
  end

  protected
   
    def find_user
      @user = User.find(params[:id])
    end
end
