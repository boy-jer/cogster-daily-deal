class BusinessOption < ActiveRecord::Base
  has_many :businesses
  validates_uniqueness_of :category
end
