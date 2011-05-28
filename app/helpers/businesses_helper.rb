module BusinessesHelper

  def conditional_purchase_link(name, options, alt = nil)
    link_to_if(purchase_possible?, name, new_business_purchase_url(@business, :protocol => 'https'), options) do 
      content_tag(:span, alt, :class => current_user_involved?) if alt 
    end
  end

  def current_user_involved?
    if current_user && current_user.made_purchase_for?(@business.current_project)
      'supported'
    end
  end

  def dt_dd_address(business)
    if business.address.present?
      content_tag(:dt, 'Address') + 
      business.address.to_a.map{|elm| content_tag(:dd, elm) }.join.html_safe
    end
  end

  def dt_dd_email(business)
    if business.email.present?
      content_tag(:dt, 'Email') + content_tag(:dd, mail_to(business.email))
    end
  end

  def dt_dd_phone(business)
    if business.address && business.phone.present?
      content_tag(:dt, 'Phone') + content_tag(:dd, business.phone)
    end
  end

  def dt_dd_website(business)
    if business.website.present? 
      content_tag(:dt, 'Website') +
      content_tag(:dd, link_to(business.website.url, business.website.url, :target => '_blank'))
    end
  end

  def other_community_title(business_counter)
    if business_counter > 0 && @businesses[0...business_counter].map{|b| b.community.name }.uniq == [community_name] && @businesses[business_counter].community.name != community_name
      content_tag(:h3, "Other Businesses")
    end
  end

  def purchase_possible?
    if current_user
      current_user.may_make_purchase_for?(@business.current_project)
    else
      @business.accepting_purchases?
    end
  end

  def rating_for(cog)
    #don't delete this; it's called in shared template but should return nil
    #outside of communities controller
  end
end
