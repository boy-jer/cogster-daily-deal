class ProjectOptionsController < ApplicationController
  before_filter :find_project_option, :only => [ :destroy, :edit, :update ]

  def create
    @project_option = ProjectOption.new(params[:project_option])
    if @project_option.save
      redirect_to admin_project_options_path, :notice => "New project option has been created"
    else
      render :new
    end
  end

  def destroy
    @project_option.destroy
    redirect_to admin_project_options_path, :notice => "The project option '#{@project_option.description}' has been deleted"
  end

  def edit
  end

  def index
    @project_options = ProjectOption.includes(:projects)
  end

  def new
    @project_option = ProjectOption.with_redemption_schedule
  end

  def show
    @project_option = ProjectOption.includes({ :projects => :business }).find(params[:id])
  end

  def update
    if @project_option.update_attributes(params[:project_option])
      redirect_to admin_project_options_path, :notice => "Project option updated"
    else
      render :edit
    end
  end

  protected

    def find_project_option
      @project_option = ProjectOption.find(params[:id])
    end
end
