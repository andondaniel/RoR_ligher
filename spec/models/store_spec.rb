require 'spec_helper'
describe Store do  
  let(:store) {FactoryGirl.create(:store)}
  
  describe '.update_slug' do
    it 'slug should eql name parameterize' do
      store.update_slug.should be_true
      store.slug.should == store.name.parameterize
    end
  end

  describe '.to_param' do
    it "should return slug value" do
      store.to_param.should == store.slug
    end
  end


end