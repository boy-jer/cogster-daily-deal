class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_business
  before_filter :find_project, :only => [ :destroy, :edit, :show, :update ]

  def create
    @project = @business.projects.new(params[:project])
    if @project.save
      redirect_to merchant_or_admin_url, :notice => "New project created"
    else
      map_project_options
      render :new
    end
  end

  def destroy
    @project.destroy
    redirect_to merchant_or_admin_url, :notice => "The project has been deleted"
  end

  def edit
    map_project_options
  end

  def index
    @project = Project.first
  end

  def new
    @project = Project.new
    map_project_options
  end

  def show

  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to merchant_or_admin_url, :notice => "The project has been updated"
    else
      map_project_options
      render :edit
    end
  end
  protected

    def find_business
      @business = Business.find(params[:business_id])
    end

    def find_project
      @project = @business.projects.find(params[:id])
    end

    def map_project_options
      @project_options = ProjectOption.all.map{|c| [c.description, c.id]}
    end

    def merchant_or_admin_url
      current_user.merchant?? account_url : admin_business_url(@business)
    end
end
