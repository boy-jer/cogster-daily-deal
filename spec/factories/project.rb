Factory.define :project do |project|
  project.association :business
  project.name "Our Test Project"
  project.amount 50
  project.goal 250
  project.reason "Because we need it for the tests"
  project.association :project_option
  project.active true
end
