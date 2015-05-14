module BanquetCoursex
  class Course < ActiveRecord::Base
    attr_accessor :category_name, :last_updated_by_name
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :category, :class_name => 'Commonx::MiscDefinition'
      
    validates_presence_of :name
    validates :name, :uniqueness => { :case_sensitive => false, :message => I18n.t('Must be unique!') }
    validates_numericality_of :category_id, :greater_than => 0, :only_integer => true, :if => 'category_id.present?'
    validates_numericality_of :good_for_how_many, :greater_than => 0, :only_integer => true, :if => 'good_for_how_many.present?'        
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_course', 'banquet_coursex')
      eval(wf) if wf.present?
    end
  end
end
