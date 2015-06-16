module BanquetCoursex
  class Course < ActiveRecord::Base
    attr_accessor :category_name, :last_updated_by_name
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :category, :class_name => 'Commonx::MiscDefinition'
      
    validates :name, :presence => true
    validates :name, :uniqueness => { :case_sensitive => false, :message => I18n.t('Must be unique!') }
    validates :category_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'category_id.present?'
    validates :good_for_how_many, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'good_for_how_many.present?'        
    validates :est_cost, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'est_cost.present?'       
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_course', 'banquet_coursex')
      eval(wf) if wf.present?
    end
  end
end
