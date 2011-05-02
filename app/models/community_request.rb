class CommunityRequest < ActiveRecord::Base
  after_destroy :send_negative_feedback
  validates_presence_of :email, :zip_code

  attr_accessor :message

  def destroy_with_positive_feedback(msg)
    UserMailer.accept_community_request(self, msg).deliver
    delete
  end

  protected

    def send_negative_feedback
      UserMailer.deny_community_request(self).deliver
    end
end
