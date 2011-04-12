class UsersController < ApplicationController
  before_filter :find_user, :except => [ :create, :index, :new ]
  before_filter :set_options, :only => [:new, :edit]

  def create
    @user = User.new(params[:user])
    @user.terms = "1"
    @user.role = params[:user][:role]
    if @user.merchant?
      @user.business.community_id = @user.community_id
    else
      @user.business = nil 
    end
    if @user.save
      redirect_to admin_users_path, :notice => "An account for #{@user.name} has been created"
    else
      set_options
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, :notice => "#{@user.name}'s account has been deleted'"
  end

  def edit

  end

  def index
    @merchants = User.where(['role = ?', 'merchant']).includes(:business, :community).sort{|a, b| b.business.active <=> a.business.active }
    @cogsters = User.where(['role = ?', nil]).includes(:community)
    @admin = User.where(['role = ?', 'admin'])
  end

  def new
    @user = User.new 
  end

  def show

  end

  def update
    if @user.update_attributes(params[:user])
      @user.role = params[:user][:role]
      @user.save
      redirect_to admin_users_path, :notice => "#{@user.name} has been updated"
    else
      set_options
      render :edit
    end
  end

  protected
   
    def find_user
      @user = User.find(params[:id])
    end

    def set_options
      @options = Community.all.map{|c| [c.name, c.id] }
      @business_options = %w(restaurant)
    end
end
