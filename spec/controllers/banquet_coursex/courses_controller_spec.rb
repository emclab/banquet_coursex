require 'rails_helper'

module BanquetCoursex
  RSpec.describe CoursesController, type: :controller do

    routes {BanquetCoursex::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
           
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      piece = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "set, piece")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @cate = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'banquet_course_category')
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns dish courses" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "BanquetCoursex::Course.where(:available => true).order('created_at DESC')")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquet_coursex_course, :available => true)
        task1 = FactoryGirl.create(:banquet_coursex_course, :name => 'a new task', available: true)
        get 'index'
        expect(assigns(:courses)).to match_array([task1, task])
      end
      
      it "should only return the course for a category_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "BanquetCoursex::Course.where(:available => true).order('created_at DESC')")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquet_coursex_course, :category_id => @cate.id, available: true)
        task1 = FactoryGirl.create(:banquet_coursex_course, :category_id => @cate.id + 1, :name => 'a new task', available: true)
        get 'index', {:category_id => @cate.id}
        expect(assigns(:courses)).to  match_array([task])
      end
            
    end
  
    describe "GET 'new'" do
      it "returns bring up new page" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        get 'new', { :category_id => @cate.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.attributes_for(:banquet_coursex_course, :category_id => @cate.id )  
        get 'create', {:course => task, :category_id => @cate.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.attributes_for(:banquet_coursex_course, :category_id => @cate.id, :name => nil)
        get 'create', {:course => task, :category_id => @cate.id}
        expect(response).to render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        
        task = FactoryGirl.create(:banquet_coursex_course, :category_id => @cate.id)
        get 'edit', {:id => task.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquet_coursex_course, :category_id => @cate.id)
        get 'update', {:id => task.id, :course => {:name => 'new name'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquet_coursex_course)
        get 'update', {:id => task.id, :course => {:name => ''}}
        expect(response).to render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:banquet_coursex_course, :category_id => @cate.id, :last_updated_by_id => @u.id)
        get 'show', {:id => task.id}
        expect(response).to be_success
      end
    end
  end
end
