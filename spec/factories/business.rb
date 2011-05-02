Factory.define :business do |business|
  business.name "BJ's Ribs"
  business.description "A place for ribs"
  business.association :address
  business.association :community
  business.association :business_option
end
