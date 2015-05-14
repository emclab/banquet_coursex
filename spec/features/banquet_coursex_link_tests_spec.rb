require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
  describe "GET /banquet_coursex_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link',
         'right-span#'         => '2', 
         'left-span#'         => '6', 
         'offset#'         => '2',
         'form-span#'         => '4'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      piece_unit = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "set, piece")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "BanquetCoursex::Course.where(:available => true).order('created_at DESC')")
        
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'banquet_coursex_courses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_banquet_course_category', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
             
      @cate = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'banquet_course_category')
      
      visit authentify.new_session_path
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      task = FactoryGirl.create(:banquet_coursex_course, available: true, :category_id => @cate.id, :last_updated_by_id => @u.id)
      visit banquet_coursex.courses_path
      save_and_open_page
      expect(page).to have_content('Courses')
      click_link 'Edit'
      expect(page).to have_content('Update Course')
      #save_and_open_page
      fill_in 'course_name', :with => 'a test Course'
      click_button 'Save'
      visit banquet_coursex.courses_path
      expect(page).to have_content('a test Course')
      #with wrong data
      visit banquet_coursex.courses_path
      expect(page).to have_content('Courses')
      click_link 'Edit'
      fill_in 'course_name', :with => ''
      fill_in 'course_ingredient_spec', :with => 'this will never show'
      click_button 'Save'
      save_and_open_page
      visit banquet_coursex.courses_path
      expect(page).not_to have_content('this will never show')
            
      visit banquet_coursex.courses_path
      click_link task.id.to_s
      #save_and_open_page
      expect(page).to have_content('Course Info')
      #click_link 'New Log'
      #save_and_open_page
      #expect(page).to have_content('Log')
      
      visit banquet_coursex.courses_path
      #save_and_open_page
      click_link 'New Dish'
      save_and_open_page
      expect(page).to have_content('New Course')
      fill_in 'course_name', :with => 'a test Course new'
      fill_in 'course_ingredient_spec', :with => 'a test spec'
      click_button 'Save'
      visit banquet_coursex.courses_path
      expect(page).to have_content('a test Course new')
      #with wrong data
      visit banquet_coursex.courses_path
      #save_and_open_page
      click_link 'New Dish'
      fill_in 'course_name', :with => ''
      fill_in 'course_ingredient_spec', :with => 'a test spec will never show up'
      click_button 'Save'
      #save_and_open_page
      visit banquet_coursex.courses_path
      expect(page).not_to have_content('a test spec will never show up')
           
    end
  end
end
