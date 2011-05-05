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
    else
      link_to "Print Cash", cash_path(coupon.purchase, :pdf), :class => "button"
    end
  end

  def coupon_rows(coupons, user)
    coupons.map do |coupon|
      content_tag(:td, user.abbr_name) +
      content_tag(:td, user.cogster_id) +
      valid_days_for(coupon).html_safe
    end
  end

  def empty_td_tag(width)
    width > 0 ? content_tag(:td, ' ', :colspan => width) : ''
  end

  def expiration_status(coupon)
    "#{cycle('odd', 'even')} #{coupon.expired?? 'expired' : !coupon.future?? 'active' : ''}"  
  end

  def new_or_edit_project_link(project)
    if project.new_record?
      link_to 'Create a Project', new_business_project_path(current_user.business)
    else
      link_to 'Edit Your Project', edit_business_project_path(current_user.business, project)
    end
  end

  def redeemable_coupons_for(user, purchase)
    coupons = purchase.coupons.for_week_and_project(@monday, @current_project)
    return "" if coupons.empty?
    coupon_rows(coupons, user).map do |row|
      content_tag :tr, row 
    end.join.html_safe
  end

  def valid_days_for(coupon)
    start = [0, coupon.start_date - @monday].max.to_i
    week_end = [0, @monday - coupon.expiration_date + 6].max.to_i
    middle = 7 - start - week_end
    empty_td_tag(start) +
    content_tag(:td, link_to(number_to_currency(coupon.remainder), edit_business_coupon_path(@current_project.business, coupon)), :colspan => middle, :class => "outstanding_cash") +
    empty_td_tag(week_end)
  end
end
