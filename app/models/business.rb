class Business < ActiveRecord::Base
  belongs_to :merchant, :class_name => 'User'
  has_many :websites
  belongs_to :community
  has_one :address, :as => :addressable
  has_many :projects
  has_one :current_project, :class_name => 'Project', :conditions => { :active => true }
  delegate :supporters, :to => :current_project

  def current_project_with_ensure
    current_project_without_ensure || Project.new(:goal => 0)
  end
  alias_method_chain :current_project, :ensure

  def image
    'default.jpg'
  end

  def medium_image
    'default_medium.png'
  end

  def to_param
    "#{id}-#{name.gsub(/'/,'').gsub(/\W+/, '-').gsub(/^-+/,'').gsub(/-+$/,'').downcase}"
  end
end
