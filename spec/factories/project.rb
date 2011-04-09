Factory.define :project do |project|
  project.association :business
  project.name "Our Test Project"
  project.max_amount 50
  project.goal 250
  project.reason "Because we need it for the tests"
  project.expiration_date Time.new.next_month
  project.association :project_option
  project.active true
end
