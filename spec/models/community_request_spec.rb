require 'spec_helper'

describe CommunityRequest do

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:zip_code) }

  let(:request)  { Factory(:community_request) }

  before :each do
    reset_mailer
  end

  describe "#destroy" do
    it "sends an email" do
      request.destroy
      unread_emails_for(request.email).should have(1).message
    end
  end

  describe "#destroy_with_positive_feedback" do
    it "sends an email and destroys the request" do
      request.destroy_with_positive_feedback("you're in!")
      unread_emails_for(request.email).should have(1).message
      expect { CommunityRequest.find(request.id) }.to raise_error
    end
  end
end
