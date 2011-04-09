class RegistrationsController < Devise::RegistrationsController
  before_filter :set_communities

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  protected

  #def after_sign_up_path_for(resource)
  #  account_path(resource)
  #end

  def set_communities
    find_community
    @options = @communities.map{|c| [c.name, c.id]}
  end
end
