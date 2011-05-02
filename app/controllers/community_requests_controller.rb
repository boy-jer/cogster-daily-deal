class CommunityRequestsController < ApplicationController
  skip_before_filter :authenticate_user!, :except => :destroy

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

  def destroy
    community_request = CommunityRequest.find(params[:id])
    community_request.message = params[:message]
    community_request.destroy
    redirect_to root_url, :notice => "The community request was deleted. Your response will be sent to #{community_request.email}."
  end
end

