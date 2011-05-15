class Website < ActiveRecord::Base
  validates_uniqueness_of :url
  before_validation :delete_blank
  before_save :check_protocol
  attr_accessor :label
  SOCIAL_MEDIA = %w(facebook twitter youtube)

  SOCIAL_MEDIA.each do |site|
    (class << self; self; end).instance_eval do
      define_method site do
        where(['websites.url LIKE ?', "%#{site}%"]).first
      end
    end
  end

  def homepage?
    SOCIAL_MEDIA.none?{|domain| url =~ /#{domain}/} 
  end

  protected

    def check_protocol
      self.url = "http://#{url}" unless url =~ /^http/
    end

    def delete_blank
      if url.blank?
        destroy 
        return false
      end
    end

end
