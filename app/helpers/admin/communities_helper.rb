module CommunitiesHelper

  def menu
    if action_name == "index"
      admin_menu
    elsif action_name == "show"
      super
    else
      breadcrumbs [link_to('Communities', admin_communities_path), menu_end]
    end
  end

  def menu_end
    case action_name
    when 'show'
      @community.name
    when 'edit', 'update'
      [link_to(@community.name, admin_community_path(@user)), 'Edit']
    when 'new', 'create'
      'New Project Option'
    end
  end

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
