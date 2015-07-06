def omniauth_mock(uid, email)
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:facebook] = {
      :uid => uid,
      :provider => "facebook",
      :info => {:nickname => 'jacob', first_name: "Jacob", last_name: 'williams', email: email},
      :credentials => {:token => "abc", :expires_at => 2.days.from_now},
      :extra => {"user_hash" => {:id => "123", :email => email}}
  }
end


Given /^I am signed in with provider facebook$/ do
  omniauth_mock("123", "jacob1@abc.com")
  visit "/auth/facebook"
end
