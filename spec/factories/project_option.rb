Factory.define :project_option do |project_option|
  project_option.description "One Month Double"
  project_option.redemption_schedule [ { :duration => 7, :percentage => 50 },
                                       { :duration => 7, :percentage => 50 },
                                       { :duration => 7, :percentage => 50 },
                                       { :duration => 7, :percentage => 50 }]
  project_option.active true
end
