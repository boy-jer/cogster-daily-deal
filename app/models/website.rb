class Website < ActiveRecord::Base
  validates_presence_of :url
  validates_uniqueness_of :url

  %w(website facebook twitter youtube).each do |site|
    (class << self; self; end).instance_eval do
      define_method site do
        where(['websites.url LIKE ?', "%#{site}%"]).first
      end
    end
  end

end
