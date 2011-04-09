class UsersController < ApplicationController
  before_filter :find_user, :except => [ :create, :index, :new ]

  def create

  end

  def destroy

  end

  def edit

  end

  def index
    @users = User.all
  end

  def new

  end

  def show

  end

  def update

  end

  protected
   
    def find_user
      @user = User.find(params[:id])
    end
end
