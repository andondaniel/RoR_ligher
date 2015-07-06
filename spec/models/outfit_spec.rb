require 'spec_helper'

describe Outfit do

  let(:outfit) { FactoryGirl.create(:outfit) }
  let(:outfit_mock) { stub_model(Outfit) }
  let(:scene) { stub_model(Scene) }

  describe ".as_json" do
    it "should include id, text" do
      outfit.as_json[:id].should == outfit.id
      outfit.as_json[:text].should == outfit.slug
    end
  end

  describe ".character_scene_source_consistency" do
    let(:message_error) { ["Outfit outfits cannot belong to a scene of a show/movie which doesn't contain their character"] }

    it "should return error message if movie is present and movie not contain in scenes movies " do
      scene.stub(:movie).and_return(stub_model(Movie, id: 1))
      outfit_mock.stub(:movie).and_return(stub_model(Movie, id: 2))
      outfit_mock.stub(:scenes).and_return([scene])
      outfit_mock.character_scene_source_consistency.should be_true
      outfit_mock.errors.full_messages.should == message_error
    end

    it "should return error message if show is present and show not contain in scenes shows " do
      scene.stub(:show).and_return(stub_model(Show, id: 1))
      outfit_mock.stub(:show).and_return(stub_model(Show, id: 2))
      outfit_mock.stub(:scenes).and_return([scene])
      outfit_mock.character_scene_source_consistency.should be_true
      outfit_mock.errors.full_messages.should == message_error
    end

  end

  describe ".update_slug" do
    it "should be true" do
      outfit.update_slug.should be_true
      outfit.slug.should == ["outfit", outfit.id].join("-")
    end
  end

  describe ".active_products" do
    it "should be true" do
      outfit_mock.stub(:products).and_return(stub_model(Product, verified: true, approved: true))
      outfit_mock.active_products.should be_true
    end

    it "should be false" do
      outfit_mock.stub(:products).and_return(stub_model(Product, verified: false, approved: false))
      outfit_mock.active_products.should be_false
    end
  end

  describe ".missing_verifications" do
    it "should return to fail message" do
      outfit_mock.stub(:active_products).and_return(["mock active product"])
      result = outfit_mock.missing_verifications
      result.should_not include("Missing active products")
      result.should include("Missing episode(s)")
      result.should include("Missing character")
      result.should include("Missing outfit image")
    end

    it "should return to success message" do
      outfit_mock.stub(:active_products).and_return(["mock active product"])
      outfit_mock.stub(:episodes).and_return(["mock episodes"])
      outfit_mock.stub(:character).and_return("mock character")
      outfit_mock.stub(:outfit_images).and_return(["mock outfit images"])
      result = outfit_mock.missing_verifications
      result.should_not include("Missing active products")
      result.should_not include("Missing episode(s)")
      result.should_not include("Missing character")
      result.should_not include("Missing outfit image")
      result.should include("All verification conditions met")
    end
  end

  describe ".update_verification" do
    it "should be true and set verified to true" do
      outfit_mock.stub(:active_products).and_return(["mock active product"])
      outfit_mock.stub(:episodes).and_return([stub_model(Episode, show: stub_model(Show))])
      outfit_mock.stub(:character).and_return(stub_model(Character))
      outfit_mock.stub(:outfit_images).and_return(["mock outfit images"])
      outfit_mock.update_verification.should be_true
      outfit_mock.verified.should be_true
    end

    it "should be true and set verified to false" do
      outfit_mock.stub(:movie).and_return(stub_model(Movie))
      outfit_mock.update_verification.should be_true
      outfit_mock.verified.should be_false
    end
  end

  describe ".to_label" do
    it "should return slug" do
      outfit_mock.to_label.should == "Outfit #{outfit_mock.id}"
    end
  end

  describe ".to_s" do
    it "should return slug" do
      outfit_mock.to_s.should == "Outfit #{outfit_mock.id}"
    end
  end

  describe ".has_exact_match?" do
    it "should not nil" do
      outfit_mock.stub(:outfit_products).and_return([stub_model(OutfitProduct, exact_match: true)])
      outfit_mock.has_exact_match?.should_not be_nil
    end
  end

  describe ".filter_attributes" do
    it "should include the attributes" do
      outfit_mock.stub(:character).and_return(stub_model(Character, gender: "Male", name: "Jacob"))
      outfit_mock.stub(:episodes).and_return([stub_model(Episode, show: stub_model(Show))])
      outfit_mock.filter_attributes.should include("Male")
      outfit_mock.filter_attributes.should include("Jacob")
    end
  end


  describe ".mobile_thumb_image_url" do
    it "should return avatar url and include 'mobile_thumb'" do
      outfit.mobile_thumb_image_url.should be_present
      outfit.mobile_thumb_image_url.should include('mobile_thumb')
    end
  end

  describe ".mobile_full_image_url" do
    it "should return avatar url and include 'mobile_full'" do
      outfit.mobile_full_image_url.should be_present
      outfit.mobile_full_image_url.should include('mobile_full')
    end
  end

  describe ".recent_airdate" do
    it "should return recent airdate" do
      outfit.recent_airdate.should < Time.now
    end
  end

  describe ".existing_products_exact" do
    it "should include the product id by logic" do
      outfit_products = [stub_model(OutfitProduct, exact_match: true, product_id: 1),
                         stub_model(OutfitProduct, exact_match: true, product_id: 2)]
      outfit_mock.stub(:outfit_products).and_return(outfit_products)
      outfit_products.stub(:build).with(exact_match: true, product_id: 1).and_return(true)
      expect(outfit_mock.existing_products_exact=([1])).to   eq([1])
    end
  end

  describe ".existing_products_non_exact" do
    it "should include the product id by logic" do
      outfit_products = [stub_model(OutfitProduct, exact_match: true, product_id: 1),
                         stub_model(OutfitProduct, exact_match: true, product_id: 2)]
      outfit_mock.stub(:outfit_products).and_return(outfit_products)
      outfit_products.stub(:build).with(exact_match: false, product_id: 1).and_return(true)
      expect(outfit_mock.existing_products_non_exact=([1])).to   eq([1])
    end
  end

end