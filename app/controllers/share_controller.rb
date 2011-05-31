class ShareController < ApplicationController
  skip_before_filter :authenticate_user!

  def facebook
    title = CGI.escape('Cogster: Double Your Money.')
    url = CGI.escape("http://www.cogster.com#{business_path(params[:id])}")
    final_url = "http://www.facebook.com/sharer.php?u=#{url}&t=#{title}"
    redirect_to final_url
  end

  def twitter
    destination = "http://www.cogster.com#{business_path(params[:id])}"
    url = BitlyResponse.short_url(destination)
    tweet = "Cogster: Double Your Money. @CogsterDotCom#{url}"
    final_url = "http://twitter.com/home?status=#{CGI.escape(tweet)}"
    redirect_to final_url
  end

end
