Factory.define :community do |community|
  community.name "Susquehanna Valley"
  community.state "PA"
  community.active true
  community.description "Where we started"
  community.event_start_date Date.today - 3
  community.event_completion_date Date.today + 4
  community.redemption_start Date.today #this is a hack to get steps to work
end
