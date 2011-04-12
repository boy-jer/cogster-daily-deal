class AccountsController < ApplicationController
  before_filter :find_community, :except => :cash

  def cash
    @purchase = current_user.purchases.find(params[:id], :include => :coupons)
    @coupon = @purchase.current_coupon
    render :layout => 'header'
  end

  def show
    if current_user.merchant?
      @current_project = current_user.business.current_project
    elsif current_user.admin?
      @inactives = Business.where(['active = ?', false])
    else
      @purchases = current_user.purchases.includes([{ :project => :business }, :coupons])
    end
    render current_user.role.downcase
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
      @options = @communities.map{|c| [c.name, c.id]}
      if current_user.merchant? 
        @business = current_user.business
        render  'edit_merchant' 
      else
       render 'edit'
      end
    end
end
