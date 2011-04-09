class CommunityRequestsController < ApplicationController
  skip_before_filter :authenticate_user!

  def new
    @community_request = CommunityRequest.new
  end

  def create
    @community_request = CommunityRequest.new(params[:community_request])
    if verify_recaptcha(:model => @community_request, :timeout => 10) && @community_request.save
      redirect_to root_url, :notice => "Thanks! We'll get right on that"
    else
      render :new
    end
  end

end

