require 'spec_helper'

describe Color do
  it "has a working factory" do
    FactoryGirl.create(:color).should be_valid
  end
end