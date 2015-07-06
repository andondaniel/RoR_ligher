require 'spec_helper'

describe ProductCategory do
  let(:product_category) {FactoryGirl.create(:product_category)}

  describe ".to_s" do
    it "should include gender and name" do
      product_category.to_s.should == "#{product_category.gender}: #{product_category.name}"
    end
  end

  describe ".to_label" do
    it "should include gender and name" do
      product_category.to_label.should == "#{product_category.gender}: #{product_category.name}"
    end
  end

  describe ".singular?" do
    it "should be true" do
      product_category.name = "Jacob"
      product_category.singular?.should be_true
    end

    it "should be false" do
      product_category.name = "Jacobs"
      product_category.singular?.should be_false
    end
  end


end