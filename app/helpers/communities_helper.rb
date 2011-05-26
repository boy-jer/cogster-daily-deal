module CommunitiesHelper

  def other_community_title(business_counter)
    #used in businesses_helper
  end

  def rating_for(cog)
    number_with_precision cog.swag_rank, :precision => 1
  end
end
