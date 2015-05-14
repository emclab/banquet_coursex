require 'rails_helper'

module BanquetCoursex
  RSpec.describe Course, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:banquet_coursex_course)
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:banquet_coursex_course, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 category_id" do
      c = FactoryGirl.build(:banquet_coursex_course, :category_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should take nil category_id" do
      c = FactoryGirl.build(:banquet_coursex_course, :category_id => nil)
      expect(c).to be_valid
    end
    
    it "should reject dup name for the dish" do
      c = FactoryGirl.create(:banquet_coursex_course, :name => "nil")
      c1 = FactoryGirl.build(:banquet_coursex_course, :name => "Nil")
      expect(c1).not_to be_valid
    end
    
  end
end
