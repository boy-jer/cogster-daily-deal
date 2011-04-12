class CommunitiesController < ApplicationController
  before_filter :find_community, :only => [ :edit, :update, :destroy ]
  skip_before_filter :authenticate_user!, :only => :show

  def create
    @community = Community.new(params[:community])
    if @community.save
      redirect_to admin_communities_path, :notice => "The community of '#{@community.name}' has been added"
    else
      render :new
    end
  end

  def destroy
    @community.destroy
    redirect_to admin_communities_path, :notice => "The community of '#{@community.name}' has been deleted"
  end

  def edit

  end

  def index
    @communities = Community.includes(:businesses, :inactive_businesses)
  end

  def new
    @community = Community.new
  end

  def show
    if params[:id]
      @community = Community.find(params[:id])
      @businesses = Business.find_all_by_community_id(params[:id])
    elsif params[:community_id]
      @community = Community.includes(:businesses => { :current_project => :purchases }).find(params[:community_id])
      @communities = Community.all.reject{|c| c == @community }
      @businesses = @community.businesses
      @businesses.sort_by!(&params[:sort].to_sym) if params[:sort]
    end
    @cogs = User.where(["community_id = ?", params[:id]])
  end

  def update
    if @community.update_attributes(params[:community])
      redirect_to admin_communities_path, :notice => "Community updated"
    else
      render :edit
    end
  end

  protected

  def find_community
    @community = Community.find(params[:id])
  end
end
