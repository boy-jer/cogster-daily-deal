Factory.define :community do |community|
  community.name "Susquehanna Valley"
  community.state "PA"
  community.active true
  community.description "Where we started"
  community.event_start_date Date.today - 3
  community.event_completion_date Date.today + 4
end
