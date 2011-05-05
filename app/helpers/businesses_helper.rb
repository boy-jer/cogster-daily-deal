module BusinessesHelper

  def conditional_purchase_link(name, options, alt = nil)
    link_to_if(purchase_possible?, name, new_business_purchase_path(@business), options) do 
      content_tag(:span, alt) if alt 
    end
  end

  def hour_options
    options_for_select (1..12).to_a
  end

  def meridian_options
    options_for_select %w(am pm)
  end

  def minute_options
    options_for_select (0..59).map{|n| sprintf "%02d", n }.to_a
  end

  def purchase_possible?
    if current_user
      current_user.may_make_purchase_for?(@business.current_project)
    else
      @business.accepting_purchases?
    end
  end

  def rating_for(cog)

  end
end
