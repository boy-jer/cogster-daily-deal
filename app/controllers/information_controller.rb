class InformationController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :find_community

  def terms
  end

  def faq
  end

  def privacy
  end

  def local
  end

  def swag
  end

  def contact
  end
end
