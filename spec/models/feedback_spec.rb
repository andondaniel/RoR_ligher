require 'spec_helper'

describe Feedback do
  describe '.status_options' do
    it "should include 'Filed on Github' in result" do
      Feedback.status_options.should include("Filed on Github")
    end

    it "should include 'Closed' in result" do
      Feedback.status_options.should include("Closed")
    end

    it "should include 'On Hold' in result" do
      Feedback.status_options.should include("On Hold")
    end

    it "should include 'Rejected' in result" do
      Feedback.status_options.should include("Rejected")
    end

    it "should include 'nil' in result" do
      Feedback.status_options.should include(nil)
    end
  end

  describe '.feedback_categories' do
    it "should include 'Bug Report' in result" do
      Feedback.feedback_categories.should include("Bug Report")
    end

    it "should include 'Suggestion' in result" do
      Feedback.feedback_categories.should include("Suggestion")
    end

    it "should include 'Question' in result" do
      Feedback.feedback_categories.should include("Question")
    end

    it "should include 'Comment' in result" do
      Feedback.feedback_categories.should include("Comment")
    end

    it "should include 'Other' in result" do
      Feedback.feedback_categories.should include('Other')
    end
  end
end
