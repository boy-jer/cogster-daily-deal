module Admin::UsersHelper

  def last_sign_in_for(user)
    if user.last_sign_in_at
      user.last_sign_in_at.strftime("%r %b %d")
    else
      'N/A'
    end
  end

  def role_options(user)
    if user.business
      %w(admin merchant cogster)
    else
      %w(admin cogster)
    end
  end

end
