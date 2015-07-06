require 'spec_helper'

describe MovieImage do
  it "has a working cover factory" do
    FactoryGirl.create(:movie_image_cover).should be_valid
  end

  it "has a working poster factory" do
    FactoryGirl.create(:movie_image_poster).should be_valid
  end
end