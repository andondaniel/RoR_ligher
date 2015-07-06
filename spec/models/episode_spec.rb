require 'spec_helper'

describe Episode do

  let(:episode)  {FactoryGirl.create(:episode)}


  describe ".to_param" do
    it "should return to slug" do
      episode.to_param.should == episode.slug
    end
  end

  describe ".to_label" do
    it "should return to slug" do
      episode.to_label.should == episode.slug
    end
  end

  describe ".to_s" do
    it "should return to slug" do
      episode.to_s.should == episode.slug
    end
  end

  describe ".primary_image(image_size)" do
    it "should return square image" do
      episode.primary_image(:square).should include("square")
    end
  end

  describe ".missing_verifications" do
    it "should return fail message verifications" do
      episode.missing_verifications.should == ["Less than 3 approved outfits"]
    end
  end

  describe ".update_slug" do
    it "should be true" do
      episode.update_slug.should be_true
      episode.slug.should == "#{episode.show.name}-season#{episode.season}-episode#{episode.episode_number}".parameterize
    end
  end

  describe ".active?" do
    it "should be false" do
      episode.active?.should be_false
    end

    it "should be true" do
      episode.verified = true
      episode.approved = true
      episode.active?.should be_true
    end
  end

  describe ".has_aired" do
    it "should be true" do
      episode.has_aired.should be_true
    end
  end

  describe ".mobile_thumb_image_url" do
    it "should return avatar url and include 'mobile_thumb'" do
      episode.mobile_thumb_image_url.should be_present
      episode.mobile_thumb_image_url.should include('mobile_thumb')
    end
  end



end