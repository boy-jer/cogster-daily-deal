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

  def dt_dd(business, attribute)
    if business.send(attribute).present?
      content_tag(:dt, attribute.to_s.capitalize) + content_tag(:dd, business.send(attribute))
    end
  end

  def dt_dds(business, collection, attribute)
    if business.send(collection).present? && business.send(collection).any?{|a| a.persisted? }
      content_tag(:dt, collection.to_s.capitalize) +
      business.send(collection).select{|a| a.persisted? }.map do |a|
        content_tag(:dd, link_to(a.send(attribute), a.send(attribute), :target => '_blank'))
      end.join.html_safe
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
