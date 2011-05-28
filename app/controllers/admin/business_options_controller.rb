module Admin
  class BusinessOptionsController < BaseController
    before_filter :find_option, :only => [ :destroy, :edit, :show, :update ]

    def create
      @business_option = BusinessOption.new(params[:business_option])
      if @business_option.save
        redirect_to admin_business_options_url, :notice => "#{@business_option.category} has been added"
      else
        render :new
      end
    end

    def destroy
      @business_option.destroy
      redirect_to admin_business_options_url, :notice => "#{@business_option.category} has been removed"
    end

    def edit

    end

    def index
      @business_options = BusinessOption.all
    end

    def new
      @business_option = BusinessOption.new
    end

    def show

    end

    def update
      if @business_option.update_attributes(params[:business_option])
        redirect_to admin_business_options_url, :notice => "The category name has been updated to '#{@business_option.category}'"
      else
        render :edit
      end
    end

    protected

      def find_option
        @business_option = BusinessOption.find(params[:id])
      end
  end
end
