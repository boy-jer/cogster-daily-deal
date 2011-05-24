Factory.define :business do |business|
  business.name "DJ's Pizza"
  business.description "A place for ribs"
  #business.association :address
  business.community { Community.find_by_name(Factory.attributes_for(:community)[:name]) || Factory(:community) }
  business.association :business_option

  business.after_create do |b|
    b.address = Factory(:address, :addressable => b)
  end
end
