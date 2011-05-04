module BusinessesHelper

  def conditional_purchase_link(name, options, alt = nil)
    link_to_if(purchase_possible?, name, new_business_purchase_path(@business), options) do 
      content_tag(:span, alt) if alt 
    end
  end

  def purchase_possible?
    if current_user
      current_user.may_purchase_for?(@business.current_project)
    else
      @business.accepting_purchases?
    end
  end

  def rating_for(cog)

  end
end
