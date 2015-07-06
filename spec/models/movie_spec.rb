require 'spec_helper'

describe Movie do

  let(:movie) { FactoryGirl.create(:movie) }

  describe ".to_param" do
    it "should return to slug" do
      movie.to_param.should == movie.slug
    end
  end

  describe ".to_label" do
    it "should return to slug" do
      movie.to_label.should == movie.slug
    end
  end

  describe ".primary_image" do
    it "should return to primary image and correct image size" do
      movie.primary_image(:square).should include("square")
    end
  end

  describe ".missing_verifications" do
    it 'should return ["Less than 3 approved outfits"]' do
      movie.missing_verifications.should == ["Less than 3 approved outfits"]
    end

    # TODO
    # it 'should return ["All verification conditions met"]' do
    #   movie.missing_verifications.should == ["All verification conditions met"]
    # end
  end

  describe ".update_slug" do
    it "should return true" do
      movie.update_slug.should be_true
      movie.slug.should == "#{movie.id}-#{movie.name.parameterize}"
    end
  end

  describe ".mobile_poster_image_url" do
    it "should return avatar url and include 'mobile_poster'" do
      movie.mobile_poster_image_url.should be_present
      movie.mobile_poster_image_url.should include('mobile_poster')
    end
  end

  describe ".mobile_thumb_image_url" do
    it "should return avatar url and include 'mobile_thumb'" do
      movie.mobile_thumb_image_url.should be_present
      movie.mobile_thumb_image_url.should include('mobile_thumb')
    end
  end

  describe ".mobile_cover_image_url" do
    it "should return avatar url and include 'cover'" do
      movie.mobile_cover_image_url.should be_present
      movie.mobile_cover_image_url.should include('cover')
    end
  end
end