require 'spec_helper'

describe Website do
  it "adds protocol before saving" do
    website = Website.new(:url => 'facebook.com')
    website.save
    website.url.should == 'http://facebook.com'
  end

  it "does not add protocol if user did" do
    website = Website.new(:url => 'http://www.facebook.com')
    website.save
    website.url.should == 'http://www.facebook.com'
  end

  it "deletes website if url is blank" do
    website = Website.create(:url => 'homepage.com')
    website.update_attributes(:url => '')
    Website.find_by_url(website).should be_nil
  end
end
