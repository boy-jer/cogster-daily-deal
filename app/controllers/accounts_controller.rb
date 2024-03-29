class AccountsController < ApplicationController
  before_filter :find_community, :except => :cash

  def cash
    @purchase = current_user.purchases.find(params[:id], :include => :coupons)
    @coupon = @purchase.current_coupon
    respond_to do |format|
      format.html { render :layout => 'header' }
      format.pdf { render :pdf => 'cogster_cash',
                          :layout => 'pdf',
                          :disposition => 'attachment'
                 }
    end
  end

  def show
    if session[:cogster].nil? && current_user.merchant?
      @business = current_user.business
      @current_project = @business.current_project
      @monday = Date.today.beginning_of_week
    elsif session[:cogster].nil? && current_user.admin?
      @community_requests = CommunityRequest.all
      @inactives = Business.where('active IS NULL')
    else
      @purchases = current_user.purchases.includes([{ :project => :business }, :coupons])
    end
    render session[:cogster] ? 'cogster' : current_user.role.downcase
  end

  def edit
    render_edit_template
  end

  def edit_password

  end

  def update
    if update_successful?
      redirect_to account_url, :notice => set_notice
    else
      render_edit_or_password_template
    end
  end

  protected

    def render_edit_or_password_template
      if params[:user][:password]
        render :edit_password
      else
        render_edit_template
      end
    end


    def render_edit_template
      @options = Community.all.map{|c| [c.name, c.id] }
      render 'edit'
    end

    def set_notice
      if params[:toggle].present? 
        ''
      elsif params[:user][:password]
        sign_in(@current_user, :bypass => true)
        'Your password has been updated'                
      else
        'Your profile has been updated'
      end
    end

    def set_session
      if session[:cogster]
        session[:cogster] = nil
      else
        session[:cogster] = true
      end
    end

    def update_successful?
      if params[:user]
        current_user.update_attributes(params[:user])
      elsif params[:toggle]
        set_session
        return true
      end
    end
end
