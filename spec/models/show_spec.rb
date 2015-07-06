require 'spec_helper'

describe Show do

  let(:show) {FactoryGirl.create(:show)}
  let(:show_mock) {stub_model(Show)}
  
  describe ".update_slug" do
    it "should to be true" do
      show.update_slug.should be_true
      show.slug.should == show.name.parameterize
    end
  end

  describe ".to_param" do
    it "should return slug" do
      show.to_param.should == show.slug
    end
  end

  describe ".mobile_poster_image_url" do
    it "should return avatar url and include 'mobile_poster'" do
       show.mobile_poster_image_url.should be_present
       show.mobile_poster_image_url.should include('mobile_poster')
    end
  end

  describe ".mobile_thumb_image_url" do
    it "should return avatar url and include 'mobile_thumb'" do
      show.mobile_thumb_image_url.should be_present
      show.mobile_thumb_image_url.should include('mobile_thumb')
    end
  end

  describe ".update_verification" do
    it "should set verified to true" do
      character = stub_model(Character, verified: true, approved: true)
      character.stub(:active).and_return([double('mock active')])
      show_mock.stub(:characters).and_return(character)

      episode = stub_model(Episode, verified: true, approved: true)
      episode.stub(:active).and_return([double('mock active')])
      show_mock.stub(:episodes).and_return(episode)

      show_mock.update_verification.should be_true
      show_mock.verified.should be_true
    end


    it "should set verified to false" do
      character = stub_model(Character, verified: true, approved: true)
      character.stub(:active).and_return([])
      show_mock.stub(:characters).and_return(character)

      episode = stub_model(Episode, verified: true, approved: true)
      episode.stub(:active).and_return([])
      show_mock.stub(:episodes).and_return(episode)

      show_mock.update_verification.should be_true
      show_mock.verified.should be_false
    end
  end



end