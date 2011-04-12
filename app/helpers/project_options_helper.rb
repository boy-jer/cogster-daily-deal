module ProjectOptionsHelper

  def fewer_intervals
    @project_option.redemption_schedule.length - 1
  end

  def menu          
    if action_name == "index"
      admin_menu
    else
      breadcrumbs [link_to('Project Options', admin_project_options_path), menu_end]
    end
  end

  def menu_end
    case action_name
    when 'show'
      @project_option.description
    when 'edit', 'update'
      [link_to(@project_option.description, admin_project_option_path), 'Edit']
    when 'new', 'create'
      'New Project Option'
    end
  end
end
