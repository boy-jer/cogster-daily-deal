class Community < ActiveRecord::Base
  has_many :businesses, :conditions => { :active => true },
                        :dependent => :destroy
  has_many :inactive_businesses, :class_name => "Business",
                                 :conditions => { :active => false },
                                 :dependent => :destroy
  has_many :users, :dependent => :destroy

  validates_presence_of :name

  def handle
    if super.present?
      super
    elsif state.present?
      "#{name} #{state}".parameterize
    else
      name.parameterize
    end
  end

  def to_param
    "#{id}-#{handle}"
  end
end

