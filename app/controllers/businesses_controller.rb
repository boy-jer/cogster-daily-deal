class BusinessesController < ApplicationController

  before_filter :find_business, :only => [ :destroy, :edit, :update ]
  before_filter :set_filter, :only => :index
  before_filter :find_community, :only => [ :index, :show ]

  def create
    @merchant = User.new(params[:user])   
    @merchant.build_business(params[:user][:business])
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
    @businesses = Business.includes(:current_project => :purchases).order(params[:sort])
    @businesses.sort_by!{ |b| b.current_project.supporters.count } unless params[:sort]
    if params[:search].present? || params[:filter].present?
      if params[:search]
        @businesses = @businesses.where(["name LIKE ?", "%#{params[:search]}%"])
      elsif params[:filter] != "all"
        @businesses = @businesses.where(["type = ?", params[:filter]])
      end
      if current_user
        @home_businesses, @businesses = @businesses.partition do |b|
          b.community_id == current_user.community_id
        end
      end
      render :search
    end
  end

  def new
    @merchant = User.new
    @merchant.build_business(:address => Address.new)
    set_options
  end

  def show
    @business = Business.includes(:current_project).find(params[:id])
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

    def find_community
      unless current_user && current_user.admin?
        super
      end
    end

    def set_filter
      unless current_user && current_user.admin?
        params[:filter] = "all" if params[:filter].blank? && params[:search].blank?
      end
    end

    def set_options
      @options = Community.all.map{|c| [c.name, c.id]}
      @business_options = %w(restaurant health/fitness service club apparel)
    end
end
