require 'spec_helper'

describe Admin::BusinessOptionsController do
  let(:opt){ mock_model(BusinessOption, :category => "shooting ranges") }
  before :each do
    sign_in_as_admin
  end

  def find_option
    BusinessOption.should_receive(:find).with(:id) { opt }
  end

  describe "POST create" do

    before :each do
      BusinessOption.should_receive(:new).with({ 'some' => :params }) { opt }
    end
    
    describe "on save" do

      before :each do
        opt.should_receive(:save).and_return true
        post :create, :business_option => { 'some' => :params }
      end

      it "redirects to index" do
        response.should be_redirect
      end

      it "has a flash notice about what has been added" do
        flash[:notice].should =~ /shooting ranges/
      end
    end

    describe "on failure" do
      before :each do
        opt.should_receive(:save).and_return false
        post :create, :business_option => { 'some' => :params }
      end

      it "renders new" do
        response.should render_template('new')
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      find_option
      opt.should_receive(:destroy).and_return true
      delete :destroy, :id => :id
    end

    it "redirects to index" do
      response.should be_redirect
    end

    it "has a flash notice about what has been destroyed" do
      flash[:notice].should =~ /shooting ranges/
    end
  end

  describe "PUT update" do
    before :each do
      find_option
    end

    describe "on success" do
      before :each do
        opt.should_receive(:update_attributes).with({'valid' => :attr}) { true }
        put :update, :id => :id, :business_option => { 'valid' => :attr }
      end

      it "redirects to index" do
        response.should be_redirect
      end

      it "has a flash notice..." do 
        flash[:notice].should =~ /shooting ranges/ 
      end
    end

    describe "on failure" do
      it "renders edit" do
        opt.should_receive(:update_attributes).with({ 'invalid' => :attr }) { false }
        put :update, :id => :id, :business_option => { 'invalid' => :attr }
        response.should render_template('edit')
      end
    end
  end
end
