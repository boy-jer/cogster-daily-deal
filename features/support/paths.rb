module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name        

    when /the (home|front)\s?page/
      '/'
    when /the purchase page for (.*)/
      business = Business.find_by_name($1)
      business_purchase_path(business)
    when /the account page/
      account_path
    when /the project options page/
      admin_project_options_path
    when /a project option edit page/
      edit_admin_project_option_path(ProjectOption.first)
    when /my community page/
      community_path(@user.community)
    when /the business page for (.*)/
      business = Business.find_by_name($1)
      business_path(business)
    when /the new community page/
      new_admin_community_path(:community_request_id => CommunityRequest.first)
    when /the community page/
      community_path(Community.first)
    when /the Users page/
      admin_users_path
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)

