class ProjectsController < ApplicationController
  before_filter :find_business
  before_filter :find_project, :only => [ :destroy, :edit, :update ]
  before_filter :parse_date, :only => [ :create, :update ]

  def create
    @project = @business.projects.new(params[:project])
    @project.active = true
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
    @project = @business.projects.find(params[:id], :include => { :purchases => [ :coupons, :user]})
    @purchases = @project.purchases.sort_by{|p| [p.user.abbr_name, p.created_at] }
    respond_to do |format|
      format.html { render :layout => 'header' }
      format.pdf { render :pdf => 'customer_list',
                          :layout => 'pdf',
                          :disposition => 'attachment'
                 }
    end
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

    def parse_date
      params[:project][:expiration_date] = Chronic.parse(params[:project][:expiration_date])
    end
end
