# Given(/^I am ready with all valid details for signup$/) do
#   FactoryGirl.build :user
# end

When "I fill in Email" do
  fill_in('user_email', with: Faker::Internet.email)
end

When "I fill in First name" do
  fill_in('First name', with: Faker::Name.first_name)
end

When "I fill in Last name" do
  fill_in('Last name', with: Faker::Name.last_name)
end

When "I fill in Password" do
  fill_in('user_password',  with: 'password')
end

When "I fill in Password confirmation" do
  fill_in('user_password_confirmation',  with: 'password')
end