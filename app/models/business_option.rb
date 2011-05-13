class BusinessOption < ActiveRecord::Base
  has_many :businesses
  validates_uniqueness_of :category
  validates_presence_of :category

  def to_param
    "#{id}-#{category.gsub(/'/,'').gsub(/\W+/, '-').gsub(/^-+/,'').gsub(/-+$/,'').downcase}"
  end
end
