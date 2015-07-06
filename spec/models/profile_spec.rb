require 'spec_helper'

describe Profile do
  let(:profile) { FactoryGirl.create(:profile, user: FactoryGirl.create(:user)) }

  describe ".name" do
    it "should are first_name and last_name" do
      profile.name.should == (profile.first_name + " " + profile.last_name)
    end
  end

  describe ".as_json" do
    it "should return id, name" do
      profile[:id].should == profile.id
      profile.as_json[:text].should == profile.name
    end
  end



end