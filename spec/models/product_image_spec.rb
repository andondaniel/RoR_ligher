require 'spec_helper'

describe ProductImage do
  before :each do
    @product_image = FactoryGirl.create(:product_image)
  end

  describe "width_valid?" do
    it "should return nil" do
      @product_image.width_valid?.should be_nil
    end
  end

  describe "height_valid?" do
    it "should return nil" do
      @product_image.height_valid?.should be_nil
    end
  end

  describe "ratio_valid?" do
    it "should return nil" do
      @product_image.ratio_valid?.should be_nil
    end
  end
end