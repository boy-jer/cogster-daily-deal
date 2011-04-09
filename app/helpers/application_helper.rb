module ApplicationHelper

  def admin_menu
    [link_to_unless_current('Project Options', admin_project_options_path),
     link_to_unless_current('Communities', admin_communities_path),
     link_to_unless_current('Users', admin_users_path),
     link_to_unless_current('Businesses', admin_businesses_path)].join(' | ').html_safe
  end

  def business_image(business)
    content_tag :div, :class => "business_img_container" do
      image_tag(business.image, :class => "business_profile") +
      featured_tag(business)
    end
  end

  def breadcrumbs(elements)
    elements.flatten.join('&rarr;').html_safe
  end

  def current_community_link(community = nil)
    if community
      link_to community.name, community
    else
      "Choose a community"
    end
  end

  def featured_tag(business)
    image_tag('images8/featured_overlay.png', :class => "featured_business_img") if business.featured?
  end

  def login_link
    link_to("Log In", login_path) unless user_signed_in?
  end

  def menu
    menu_without_business_filters + 
    render('shared/business_selector')
  end

  def menu_without_business_filters
    render('shared/merchant_search') +
    render('shared/community_select') 
  end

  def notice_or_alert
    if flash[:notice]
      content_tag :div, flash[:notice], :id => "notice"
    elsif flash[:alert]
      content_tag :div, flash[:alert], :id => "alert"
    end
  end

  def swag_counter
    number_with_delimiter(510000).split('').map do |n|
      content_tag :div, n
    end.join.html_safe
  end
end
