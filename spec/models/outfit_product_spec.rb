require 'spec_helper'

describe OutfitProduct do

  before :each do
    @outfit_with_active_product = FactoryGirl.create(:outfit_with_active_product)
    @outfit_product_with_active_product = OutfitProduct.first

    @outfit = FactoryGirl.create(:outfit)
    @outfit_product = OutfitProduct.last
  end


  describe ".active?" do
    it 'should be true' do
      @outfit_product.active?.should be_true
    end

    it 'should be true' do
      @outfit_product_with_active_product.active?.should be_true
    end
  end


end