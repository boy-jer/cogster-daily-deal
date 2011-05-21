module AccountsHelper

  def admin_or_merchant_view_button
    if current_user.role != 'cogster' && session[:cogster]
      contents = 
      content_tag(:h2, "User View") +
      content_tag(:p, "You are viewing the site as a Cogster. To switch back to #{current_user.role} view, click the button below.") + 
      button_to("#{current_user.role.capitalize} View", account_path(:toggle => true),  :method => :put)
      content_tag :div, contents, :class => 'toggle_view'
    end
  end

  def cash_link(coupon)
    if coupon.expired?
      'Expired'
    elsif coupon.future?
      'Future'
    elsif coupon.used?
      'Spent'
    else
      link_to "Print Cash", cash_path(coupon.purchase, :pdf), :class => "button"
    end
  end

  def empty_td_tag(width)
    width > 0 ? content_tag(:td, ' ', :colspan => width) : ''
  end

  def expiration_status(coupon)
    "#{cycle('odd', 'even')} #{coupon.expired?? 'expired' : !coupon.future?? 'active' : ''}"  
  end

  def merchant_coupon_display(coupon)
    if coupon.used?
      content_tag :td, link_to('Used', edit_business_coupon_path(@business, coupon)), :class => 'expired', :title => 'You have marked this coupon as used. Click the link to change it back.' 
    elsif coupon.future?
      content_tag :td, number_to_currency(coupon.amount), :title => "This coupon will not be available until #{coupon.start_date.strftime("%B %d")}"
    else
      content_tag :td, link_to(number_to_currency(coupon.amount), edit_business_coupon_path(@business, coupon), :class => "outstanding_cash") 
    end
  end

  def new_or_edit_project_link(project)
    if project.new_record?
      link_to 'Create a Project', new_business_project_path(current_user.business)
    else
      link_to 'Edit Your Project', edit_business_project_path(current_user.business, project)
    end
  end

end
