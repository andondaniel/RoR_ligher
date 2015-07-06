require 'spec_helper'

describe Character do
  let(:character) { FactoryGirl.create(:character) }

  describe ".to_indexed_json" do
    it 'format should json' do
      JSON.parse(character.to_indexed_json).should be_kind_of(Hash)
    end

    it 'result should include all character field except description' do
      result = JSON.parse(character.to_indexed_json)
      result.should be_kind_of(Hash)
      result.keys.should_not include("description")

      ["id", "name", "show_id", "created_at", "updated_at", "slug", "actor", "gender", "importance", "verified", "approved",
       "guest", "deleted_at", "flag", "creator_id", "movie_id"].each do |field|
        result.keys.should include(field)
      end
    end
  end


  describe ".active?" do
    it "should be false" do
      character.active?.should be_false
    end

    it "should be true" do
      character.verified = true
      character.approved = true
      character.active?.should be_true
    end
  end

  describe ".first_name" do
    it "should return first word" do
      character.first_name.should == character.name.split(" ").at(0)
    end
  end

  describe ".missing_verifications" do
    it "should return fail message verifications" do
      character.missing_verifications.should == ["Missing verified outfits"]
    end

    it "should not include 'Missing verified outfits'" do
      outfit = mock_model(Outfit)
      outfit.stub(:verified).and_return(["mock verified"])
      character.stub(:outfits).and_return(outfit)
      character.missing_verifications.should_not include("Missing verified outfits")
      character.missing_verifications.should == ["All verification conditions met"]
    end
  end

  describe ".update_verification" do
    it "should pass conditions and show is present" do
      outfit = mock_model(Outfit)
      outfit.stub(:verified).and_return(["mock verified"])
      character.stub(:outfits).and_return(outfit)
      character.show = FactoryGirl.create(:show)
      character.update_verification.should be_true
    end

    it "should pass conditions and movie is present" do
      outfit = mock_model(Outfit)
      outfit.stub(:verified).and_return(["mock verified"])
      character.stub(:outfits).and_return(outfit)
      character.movie = FactoryGirl.create(:movie)
      character.update_verification.should be_true
    end
  end

  describe ".to_param" do
    it "should return slug" do
      character.to_param.should == character.slug
    end
  end

  describe ".thumbnail_image" do
    it "should return correct size and include 'thumb'" do
      character.thumbnail_image(:thumb).should include("thumb")
    end
  end

  describe ".update_slug" do
    it "should be true and slug are id, name" do
      character.update_slug.should be_true
      character.slug.should == [character.id, character.name.parameterize].join("-")
    end

  end


  describe ".mobile_thumb_image_url" do
    it "should return avatar url and include 'mobile_thumb'" do
      character.mobile_thumb_image_url.should be_present
      character.mobile_thumb_image_url.should include('mobile_thumb')
    end
  end

  describe ".mobile_medium_image_url" do
    it "should return avatar url and include 'mobile_medium'" do
      character.mobile_medium_image_url.should be_present
      character.mobile_medium_image_url.should include('mobile_medium')
    end
  end

  describe ".mobile_full_image_url" do
    it "should return avatar url and include 'mobile_full'" do
      character.mobile_full_image_url.should be_present
      character.mobile_full_image_url.should include('mobile_full')
    end
  end


end