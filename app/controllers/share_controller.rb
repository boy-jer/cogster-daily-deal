class ShareController < ApplicationController

  def facebook
    title = CGI.escape('Cogster: Double Your Money.')
    url = CGI.escape(business_url(params[:id]))
    final_url = "http://www.facebook.com/sharer.php?u=#{url}&t=#{title}"
    redirect_to final_url
  end

  def twitter
    destination = business_url(params[:id])
    url = BitlyResponse.shorten(destination)
    tweet = "Cogster: Double Your Money. @CogsterDotCom#{url}"
    final_url = "http://twitter.com/home?status=#{CGI.escape(tweet)}"
    redirect_to final_url
  end

end
