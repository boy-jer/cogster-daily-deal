class Website < ActiveRecord::Base
  validates_uniqueness_of :url
  before_validation :delete_blank
  before_save :check_protocol
  belongs_to :business

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
