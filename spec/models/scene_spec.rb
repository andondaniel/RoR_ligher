require 'spec_helper'

describe Scene do

  let(:scene) {FactoryGirl.create(:scene)}
  let(:movie) { FactoryGirl.create(:movie) }
  let(:episode) {FactoryGirl.create(:episode)}
  let(:scene_image) {FactoryGirl.create(:scene_image)}


  describe "has_movie?" do
    it "should be false" do
      scene.has_movie?.should be_false
    end

    it "should be true" do
      scene.movie = movie
      scene.has_movie?.should be_true
    end
  end

  describe ".has_episode?" do
    it "should be false" do
      scene.has_episode?.should be_false
    end

    it "should be true" do
      scene.episode = episode
      scene.has_episode?.should be_true
    end
  end

  describe ".to_s" do
    it "should return slug value" do
      scene.to_s.should == scene.slug
    end
  end

  describe ".update_slug" do
    it "should set slug to episode.slug & scene_number if episode and scene_number are present" do
      scene.episode = episode
      scene.scene_number = Faker::Number.number(4)
      scene.update_slug.should be_true
      scene.slug.should == "#{scene.episode.slug}-scene-#{scene.scene_number}".parameterize
    end

    it "should set slug to movie.slug & scene_number if movie are present" do
      scene.episode = nil
      scene.movie = movie
      scene.update_slug.should be_true
      scene.slug.should == "#{scene.movie.slug}-scene-#{scene.scene_number}".parameterize
    end

    it "should set slug to id if above condition not pass" do
      scene.episode = nil
      scene.movie = nil
      scene.update_slug.should be_true
      scene.slug == scene.id
    end
  end

  describe ".update_verification" do
    # TODO: Later
  end

  describe ".mobile_thumb_image_url" do
    it "should return avatar url and include 'mobile_thumb'" do
      scene.mobile_thumb_image_url.should be_present
      scene.mobile_thumb_image_url.should include('mobile_thumb')
    end

    it "should return nil" do
      scene.scene_images = []
      scene.mobile_thumb_image_url.should be_nil
    end
  end

  describe ".mobile_full_image_url" do
    it "should return avatar url and include 'mobile_full'" do
      scene.scene_images = [scene_image]
      scene.mobile_full_image_url.should be_present
      scene.mobile_full_image_url.should include('mobile_full')
    end

    it "should return nil" do
      scene.scene_images = []
      scene.mobile_thumb_image_url.should be_nil
    end
  end

end