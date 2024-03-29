module Admin
  class CommunitiesController < BaseController
    before_filter :find_community, :only => [ :edit, :update, :destroy ]

    def create
      @community = Community.new(params[:community])
      if @community.save
        redirect_to admin_communities_path, :notice => "The community of '#{@community.name}' has been added"
      else
        render :new
      end
    end

    def destroy
      @community.destroy
      redirect_to admin_communities_path, :notice => "The community of '#{@community.name}' has been deleted"
    end

    def edit

    end

    def index
      @communities = Community.includes(:businesses, :inactive_businesses)
      @communities, @inactives = @communities.partition(&:active)
    end

    def new
      @community = Community.new
      if params[:community_request_id]
        @community_request = CommunityRequest.find(params[:community_request_id]) 
        @community.community_request_id = @community_request.id
      end
    end

    def update
      if @community.update_attributes(params[:community])
        redirect_to admin_communities_path, :notice => "Community updated"
      else
        render :edit
      end
    end

    protected

    def find_community
      @community = Community.find(params[:id])
    end
  end
end
