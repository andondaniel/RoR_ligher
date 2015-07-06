require 'spec_helper'

describe SceneImage do
  it "has a working factory" do
    FactoryGirl.create(:scene_image).should be_valid
  end
end