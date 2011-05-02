module CommunitiesHelper

  def rating_for(cog)
    number_with_precision cog.swag_rank, :precision => 1
  end
end
