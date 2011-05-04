class BusinessOption < ActiveRecord::Base
  has_many :businesses
  validates_uniqueness_of :category
  validates_presence_of :category
  before_validation :downcase_category

  protected

    def downcase_category
      category.downcase! if category
    end
end
