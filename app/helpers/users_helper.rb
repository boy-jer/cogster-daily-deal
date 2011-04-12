module UsersHelper

  def last_sign_in_for(user)
    if user.last_sign_in_at
      user.last_sign_in_at.strftime("%r %b %d")
    else
      'N/A'
    end
  end

  def menu
    if action_name == "index"
      admin_menu
    else
      breadcrumbs [link_to('Users', admin_users_path), menu_end]
    end
  end

  def menu_end
    case action_name
    when 'show'
      @user.name
    when 'edit', 'update'
      [link_to(@user.name, admin_user_path(@user)), 'Edit']
    when 'new', 'create'
      'New User'
    end
  end

end
