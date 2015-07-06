require 'spec_helper'

describe ProductSet do
  let(:product_set)  {stub_model(ProductSet)}

  describe ".add_products" do
    it "should return products of product set" do
      product_set.stub(:products).and_return([stub_model(Product, id: 1)])
      product_set.add_products.should include(Product.new(id: 1))
    end
  end

  describe ".add_products" do
    it "should set approved be false" do
      product = stub_model(Product, id: 1)
      product.stub(:product_set).and_return(product_set)
      Product.stub(:find).and_return(product)
      products = [product]
      product_set.stub(:products).and_return(products)
      ProductSet.stub(:destroy).and_return(true)
      product_set.add_products=(["1"])
      product_set.approved.should be_false
    end
  end
end