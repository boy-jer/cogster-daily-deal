class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :find_community

  def index
    
  end

end
