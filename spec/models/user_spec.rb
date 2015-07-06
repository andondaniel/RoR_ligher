require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:profile) { user.profile }
  let(:admin) { FactoryGirl.create(:user, role: 'Admin', admin: true) }
  #let(:user_favorited) { FactoryGirl.create(:user_favorited) }


  describe ".name" do
    it "should delegate the name method to the associated profile" do
      user.name.should == profile.name
    end

    it "should delegate the first name method to the associated profile" do
      user.first_name.should == profile.first_name
    end

    it "should delegate the last name method to the associated profile" do
      user.last_name.should == profile.last_name
    end

    it "should be a combination of the first and last name" do
      user.name.should == "#{user.first_name} #{user.last_name}"
    end

  end

  describe ".admin" do
    it "should return all admins" do
      User.admin.should include(admin)
    end

    it "should not return non-admin users" do
      User.admin.should_not include(user)
    end
  end

  describe ".is_admin?" do
    it "should return true if role is admin" do
      admin.is_admin?.should be_true
    end
    it "should return false if role is user" do
      user.is_admin?.should be_false
    end

  end

  describe ".fc_permissions?" do
    it "should return true if role is Fashion Consultant" do
      user.role = 'Fashion Consultant'
      user.fc_permissions?.should be_true
    end

    it "should return false if role is User" do
      user.role = 'User'
      user.fc_permissions?.should be_false
    end

    it "should return true if role is Data Manager" do
      user.role = 'Data Manager'
      user.fc_permissions?.should be_true
    end

    it "should return true if role is admin" do
      admin.fc_permissions?.should be_true
    end

    it "should return true if role is Superadmin" do
      user.role = "Superadmin"
      user.fc_permissions?.should be_true
    end
  end


  describe ".dm_permissions?" do
    it "should return true if role is Data Manager" do
      user.role = 'Data Manager'
      user.dm_permissions?.should be_true
    end

    it "should return false if role is User" do
      user.role = 'User'
      user.dm_permissions?.should be_false
    end

    it "should return true if role is admin" do
      admin.dm_permissions?.should be_true
    end

    it "should return true if role is Superadmin" do
      user.role = "Superadmin"
      user.dm_permissions?.should be_true
    end
  end

  describe ".admin_permissions?" do
    it "should return true if role is admin" do
      admin.admin_permissions?.should be_true
    end

    it "should return true if role is Superadmin" do
      user.role = "Superadmin"
      user.admin_permissions?.should be_true
    end

    it "should return false if role is Data Manager" do
      user.role = 'Data Manager'
      user.admin_permissions?.should be_false
    end
  end


  describe ".super_admin_permissions?" do
    it "should return false if role is admin" do
      admin.super_admin_permissions?.should be_false
    end

    it "should return false if role is Data Manager" do
      user.role = 'Data Manager'
      user.super_admin_permissions?.should be_false
    end

    it "should return true if role is Superadmin" do
      user.role = "Superadmin"
      user.super_admin_permissions?.should be_true
    end

  end

  describe '.favorites' do
    let(:user_mock) {stub_model(User)}
    it 'should return all favorited products of this user' do
      user_mock.stub(:favorited_products).and_return([stub_model(Product), stub_model(Product)])
      user_mock.stub(:favorited_outfits).and_return([stub_model(Outfit), stub_model(Outfit), stub_model(Outfit), stub_model(Outfit)])
      user_mock.stub(:favorited_shows).and_return([stub_model(Show)])
      user_mock.stub(:favorited_characters).and_return([stub_model(Character), stub_model(Character), stub_model(Character)])
      user_mock.favorites[:products].size.should == 2
      user_mock.favorites[:outfits].size.should == 4
      user_mock.favorites[:shows].size.should == 1
      user_mock.favorites[:characters].size.should == 3
    end
  end

  describe ".self.new_from_omniauth" do
    it "should return user object" do
      user_info = {email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name}
      User.new_from_omniauth(user_info).email.should == user_info[:email]
      User.new_from_omniauth(user_info).first_name.should == user_info[:first_name]
      User.new_from_omniauth(user_info).last_name.should == user_info[:last_name]
    end
  end

  describe ".review_items" do
    it "should return []" do
      user.review_items.should == []
    end
  end
end