require 'spec_helper'

describe Brand do
  let(:brand) {FactoryGirl.create(:brand)}

  describe ".to_param" do
    it "should return slug value" do
      brand.to_param.should == brand.slug
    end
  end
end