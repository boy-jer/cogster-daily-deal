module BusinessesHelper

  def conditional_purchase_link(name, options, alt = nil)
    link_to_if(@business.accepting_purchases?, name, new_business_purchase_path(@business), options) do 
      content_tag(:span, alt) if alt 
    end
  end

  def rating_for(cog)

  end
end
