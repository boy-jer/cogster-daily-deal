require 'spec_helper'

describe Admin::UsersController do

  let(:user){ mock_model(User, :set_terms_and_confirmed_and_role => nil, 
                               :set_business_community => nil) }

  let(:users) { [mock_model(User), mock_model(User)] }

  def find_user
    User.should_receive(:find).with(:id){ user }
  end

  before :each do
    sign_in_as_admin
  end

  describe "POST create" do

    before :each do
      User.should_receive(:new).with({ 'generic' => 'params' }) { user }
    end

    describe "on save" do
      before :each do
        user.should_receive(:save).and_return true
        user.should_receive(:name).and_return 'test guy'
        user.should_receive(:role).and_return 'role'
        post :create, :user => { 'generic' => 'params' }
      end

      it "redirects to admin user path" do
        response.should redirect_to admin_users_path(:type => 'role')
      end

      it "flashes name" do
        flash[:notice].should =~ /test guy/
      end

    end

    describe "on fail" do
      before :each do
        user.should_receive(:save).and_return false
        mock_options
        post :create, :user => { 'generic' => 'params' }
      end

      it "renders new" do
        response.should render_template('new')
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      find_user
      user.should_receive(:name).and_return 'test guy'
      user.should_receive(:role).and_return 'role'
      delete :destroy, :id => :id
    end

    it "redirects to admin user path" do
      response.should redirect_to admin_users_path(:type => 'role')
    end

    it "flashes name" do
      flash[:notice].should =~ /test guy/
    end

  end

  describe "GET index" do
    describe "for merchants" do
      before :each do
        User.stub_chain('merchant.includes.order.paginate') { users }
        get :index, :type => 'merchants'
      end

      it "renders merchant index" do
        response.should render_template('merchants')
      end
    end

    describe "for admin" do
      before :each do
        User.stub_chain('admin.paginate')
        get :index, :type => 'admin'
      end

      it "renders admin index" do
        response.should render_template('admin')
      end
    end

    describe "for cogsters" do
      before :each do
        User.stub_chain('cogster.includes.paginate')
        get :index
      end

      it "renders cogster index" do
        response.should render_template('index')
      end
    end
  end

  describe "PUT update" do
    before :each do
      find_user
    end

    describe "on success" do
      before :each do
        user.should_receive(:update_attributes).with({ 'role' => 'role' }).and_return true
        user.should_receive(:role=).with('role')
        user.should_receive(:save)
        user.should_receive(:name).and_return 'test guy'
        user.should_receive(:role).and_return 'role'
        put :update, :id => :id, :user => { 'role' => 'role' }
      end

      it "redirects to admin user path" do
        response.should redirect_to admin_users_path(:type => 'role')
      end

      it "flashes name" do
        flash[:notice].should =~ /test guy/
      end
    end

    describe "on failure" do
      before :each do
        user.should_receive(:update_attributes).with({ 'invalid' => 'attr' }).and_return false
        mock_options
        put :update, :id => :id, :user => { 'invalid' => 'attr' }
      end

      it "renders edit form" do
        response.should render_template('edit')
      end
    end
    
  end
end
