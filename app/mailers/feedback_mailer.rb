class FeedbackMailer < ActionMailer::Base
  def bug_report(feedback)
  	@feedback = feedback
  	mail(:to => "developers@spylight.com", :subject => "There's a Bug!", :from => "jacob@spylight.com")
  end
end
