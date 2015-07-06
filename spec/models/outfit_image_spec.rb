require 'spec_helper'

describe OutfitImage do
  it "has a working factory" do
    FactoryGirl.create(:outfit_image).should be_valid
  end
end