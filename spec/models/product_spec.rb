require 'spec_helper'

describe Product do
  let(:product) { FactoryGirl.create(:product) }
  let(:product_mock) {stub_model(Product)}

  describe ".to_param" do
    it "should return to slug" do
      product.to_param.should == product.slug
    end
  end

  describe ".to_label" do
    it "should return to slug" do
      product.to_label.should == product.slug
    end
  end

  describe ".gender" do
    it "should return gender" do
      product.gender.should == product.product_categories.first.gender
    end
  end


  describe ".missing_verifications" do
    it "should return 'All verification conditions met'" do
      product.missing_verifications.should == ["All verification conditions met"]
    end

    it "should return 'Missing product category'" do
      product = FactoryGirl.create(:product_fail_verification)
      product.missing_verifications.should == ["Missing product category"]
    end
  end

  describe ".update_verification" do
    it "should return true and product verified is true" do
      product.update_verification.should be_true
      product.verified.should == true
    end

    it "should return true and product verified is false" do
      product_fail_verification = FactoryGirl.create(:product_fail_verification)
      product_fail_verification.update_verification.should be_true
      product_fail_verification.verified.should == false
    end
  end

  describe ".update_slug" do
    it "name, id should update to slug" do
      product.update_slug.should be_true
      product.slug.should == [product.id, product.name.parameterize].join("-")
    end
  end

  describe ".filter_attributes" do
    it "should return to array" do
     product.filter_attributes.should be_kind_of(String)
    end
  end

  describe ".exact_match?" do
    it "should be false" do
      product.exact_match?(FactoryGirl.create(:outfit_with_active_product)).should be_false
    end
  end

  describe ".price" do
    it "should return min price" do
      product.price.should include("$")
    end

    it "should return nil" do
      product_new = FactoryGirl.create(:product, product_sources: [])
      product_new.price.should be_nil
    end
  end


  describe ".similar_products" do
    it "should delete similar_products" do
      product.similar_products.should be_kind_of(Array)
    end
  end

  describe ".last_episode" do
    it "should return last episode" do
      product_mock.stub(:episodes).and_return([stub_model(Episode, airdate: (Time.now - 1.day))])
      product_mock.last_episode.should be_kind_of(Episode)
    end
  end

  describe ".last_outfit" do
    it "should return last outfit" do
      # last_episode = product_mock.stub(:last_episode).and_return(stub_model(Episode, id: 1))
      # episodes = product_mock.stub(:episodes).and_return(stub_model(Episode, id: 1))
      #
      # outfit = product_mock.stub(:outfits).and_return(stub_model(Outfit))
      # active = outfit.stub(:active).and_return([double('mock active')])
      # active.stub(:any?).and_return(true)
      # condition = active.stub(:where).and_return(double('mock condition'))
      # condition.stub(:last).and_return(double('last outfit'))
      #
      # product_mock.last_outfit

      # if self.outfits.active.any?
      #   self.outfits.active.where(episodes == last_episode).last
      # else nil
      # end
    end
  end

  describe ".mobile_thumb_image_url" do
    it "should return avatar url and include 'mobile_thumb'" do
      product.mobile_thumb_image_url.should be_present
      product.mobile_thumb_image_url.should include('mobile_thumb')
    end
  end

  describe ".mobile_full_image_url" do
    it "should return avatar url and include 'mobile_full'" do
      product.mobile_full_image_url.should be_present
      product.mobile_full_image_url.should include('mobile_full')
    end
  end

end