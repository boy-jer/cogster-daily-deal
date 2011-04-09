class AccountsController < ApplicationController
  before_filter :find_community

  def show
    if current_user.merchant?
      @current_project = current_user.business.current_project
    end
    render current_user.role
  end

  def edit
    render_edit_template
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to account_url, :notice => "Your profile has been updated"
    else
      render_edit_template
    end
  end

  protected

    def render_edit_template
      if current_user.merchant? 
        @business = current_user.business
        render  'edit_merchant' 
      else
       render 'edit'
      end
    end
end
