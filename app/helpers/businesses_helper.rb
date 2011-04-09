module BusinessesHelper

  def none_like
    if params[:search].present? 
      "Sorry, no businesses were found with a name like '#{params[:search]}'"
    elsif params[:filter].present?
      "Sorry, no businesses of that type were found."
    end
  end
end
