module Admin::ProjectOptionsHelper

  def fewer_intervals
    @project_option.redemption_schedule.length - 1
  end

end
