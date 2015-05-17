require_dependency "banquet_coursex/application_controller"

module BanquetCoursex
  class CoursesController < ApplicationController
    before_action :require_employee
    before_action :load_record
        
    def index
      @title = t('Courses')
      @courses = params[:banquet_coursex_courses][:model_ar_r]  #returned by check_access_right
      @courses = @courses.where(:category_id => @category_id) if @category_id
      @courses = @courses.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('course_index_view', 'banquet_coursex')
    end
  
    def new
      @title = t('New Course')
      @course = BanquetCoursex::Course.new()
      @erb_code = find_config_const('course_new_view', 'banquet_coursex')
    end
  
    def create
      @course = BanquetCoursex::Course.new(new_params)
      @course.last_updated_by_id = session[:user_id]
      if @course.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('course_new_view', 'banquet_coursex')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Course')
      @course = BanquetCoursex::Course.find_by_id(params[:id])
      @erb_code = find_config_const('course_edit_view', 'banquet_coursex')
    end
  
    def update
      @course = BanquetCoursex::Course.find_by_id(params[:id])
      @course.last_updated_by_id = session[:user_id]
      if @course.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('course_edit_view', 'banquet_coursex')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Course Info')
      @course = BanquetCoursex::Course.find_by_id(params[:id])
      @erb_code = find_config_const('course_show_view', 'banquet_coursex')
    end
    
    def autocomplete
      @courses = BanquetCoursex::Course.order(:name).where("name like ?", "%#{params[:term]}%")
      render json: @courses.map(&:name)   # or .map {|f| "#{f.part.name}"}  
    end  
    
    def destroy
      BanquetCoursex::Course.delete(params[:id])
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    
    def load_record
      @category_id = params[:category_id].to_i if (params[:category_id] =~ /[1-9]\d*/)
    end
    
    private   

    def new_params
      params.require(:course).permit(:name,
       :category_id,
       :ingredient_spec,
       :speciality,
       :unit_price,
       :note,
       :cooking_spec,
       :comment,
       :good_for_how_many,
       :image_name,
       :image_location,
       :star_rating,
       :wf_state)
    end

    def edit_params
      params.require(:course).permit(:name,
       :category_id,
       :ingredient_spec,
       :speciality,
       :unit_price,
       :note,
       :cooking_spec,
       :comment,
       :good_for_how_many,
       :image_name,
       :image_location,
       :star_rating,
       :wf_state)
    end

  end
end
