Factory.define :business do |business|
  business.name "BJ's Ribs"
  business.description "A place for ribs"
  business.association :community
end
