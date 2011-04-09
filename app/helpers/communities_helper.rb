module CommunitiesHelper

  def progress_bar(merchant)
    render 'progress_bar'
  end

  def public_or_admin_menu
    if current_user && (current_user.admin? || current_user.merchant?) 
      admin_menu
    else
      menu
    end
  end
end
