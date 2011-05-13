class Website < ActiveRecord::Base
  validates_uniqueness_of :url
  before_save :check_protocol
  attr_accessor :label
  SOCIAL_MEDIA = %w(website facebook twitter youtube)

  SOCIAL_MEDIA.each do |site|
    (class << self; self; end).instance_eval do
      define_method site do
        where(['websites.url LIKE ?', "%#{site}%"]).first
      end
    end
  end

  protected

    def check_protocol
      self.url = "http://#{url}" unless url =~ /^http/
    end

end
