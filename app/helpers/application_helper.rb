module ApplicationHelper

  def admin_menu
    if action_name == 'index' || controller_name == 'accounts'
      admin_menu_front
    else
      admin_menu_back
    end
  end

  def admin_menu_back
    breadcrumbs [controller_index_link, action_name.titleize]
  end

  def admin_menu_front
    [link_to_unless_current('Project Options', admin_project_options_path),
     link_to_unless_current('Communities', admin_communities_path),
     link_to_unless_current('Users', admin_users_path),
     link_to_unless_current('Businesses', admin_businesses_path),
     link_to_unless_current('Business Types', admin_business_options_path)].join(' | ').html_safe
  end

  def business_image(business)
    content_tag :div, :class => "business_img_container" do
      image_tag(business.image.url, :class => "business_profile") +
      featured_tag(business)
    end
  end

  def business_search_title
    if params[:search]
      capture_haml do
        haml_tag :h3, "Search for #{params[:search]}"
      end
    elsif params[:filter]
      capture_haml do
        haml_tag :h3, "#{params[:filter].sub(/^.*-/,'').capitalize}"
      end
    end
  end

  def business_sorter
    selector = {nil => "Popularity", "name" => "Name (A-Z)", "created_at" => "Newest"}
    capture_haml do
      haml_tag :strong, selector[params[:sort]]
      haml_tag :ul do
        selector.except(params[:sort]).each do |sort, text|
          haml_tag :li, link_to(text, :sort => sort) 
        end
      end
    end
  end

  def breadcrumbs(elements)
    elements.flatten.join('&rarr;').html_safe
  end

  def community_name
    if @businesses.map(&:community_id).uniq.length == 1
      @businesses.first.community_name
    end
  end

  def controller_index_link
    link_to(controller_title, controller_index_path)
  end

  def controller_index_path
    send "#{controller_path.underscore.sub(/\//, '_')}_path"
  end

  def controller_title
    controller_name.titleize
  end

  def current_community_link(community = nil)
    if community
      link_to community.name, community
    else
      "Choose a community"
    end
  end

  def edit_business_link_if_allowed(business)
    if user_signed_in? 
      if current_user.admin? 
        link_to "Edit", edit_admin_business_path(business)
      elsif current_user.owns?(business)
        link_to "Edit", edit_business_path(business)  
      end
    end
  end

  def error_messages_for(*objects)
    options = objects.extract_options!
    object = objects.first
    options[:header_message] ||= "There was a problem #{involving(object)} this #{object.class.name.underscore.titleize}."
    messages = objects.compact.map {|o| o.errors.full_messages }.flatten
    options[:message] ||= "Please correct the following #{number_of messages, 'error'} and try again"
    unless messages.empty?
      content_tag :div, :id => "errorMessages" do
        list_items = messages.map {|msg| content_tag :li, msg }
        content_tag(:h3, options[:header_message]) + 
        content_tag(:p, options[:message]) +
        content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

  def featured_tag(business)
    image_tag('images8/featured_overlay.png', :class => "featured_business_img") if business.featured?
  end

  def hour_options(h, method)
    options_for_select (1..12).to_a, h.object.send(method)
  end

  def meridian_options(h, method)
    options_for_select %w(am pm), h.object.send(method)
  end

  def minute_options(h, method)
    options_for_select (0..59).map{|n| sprintf "%02d", n }.to_a, h.object.send(method)
  end

  def involving(object)
    object.persisted?? 'updating' : 'creating'
  end

  def login_link
    link_to("Log In", login_path) unless user_signed_in?
  end

  def menu
    if controller_path =~ /admin\//
      admin_menu
    elsif controller_path == 'purchases'
      breadcrumbs [link_to(@community.name, @community), link_to(@business.name, @business), "Make a Purchase"]
    else
      menu_without_business_filters + 
      render('shared/business_selector')
    end
  end

  def menu_without_business_filters
    render('shared/merchant_search') +
    render('shared/community_select') 
  end

  def none_like
    if params[:search].present? 
      "Sorry, no businesses were found with a name like '#{params[:search]}'"
    elsif params[:filter].present?
      "Sorry, no businesses of that type were found."
    end
  end

  def notice_or_alert
    if flash[:notice]
      content_tag :div, flash[:notice], :id => "notice"
    elsif flash[:alert]
      content_tag :div, flash[:alert], :id => "alert"
    end
  end

  def number_of(collection, word)
    collection.count > 1 ? "#{collection.count} #{word.pluralize}" : word
  end

  def swag_counter
    if @community
      digits = swag_digits.split('').map do |n|
        content_tag :div, n
      end
      swag_pad(digits).join.html_safe
    end
  end

  def swag_digits
    number_with_delimiter @community.swag_counter
  end

  def swag_pad(digits)
    (7 - digits.length).times{|n| digits.unshift content_tag(:div, '') }
    digits
  end

end
