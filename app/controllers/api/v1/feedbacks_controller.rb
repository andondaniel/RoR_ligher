class API::V1::FeedbacksController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json
  skip_before_filter :verify_authenticity_token

  resource_description do
    short "Submit feedback"
    description "Allows a user to submit feedback after they have used the app."
    formats ['json']
  end

  def_param_group :feedback_params do
    param :feedback, Hash do
      param :email, String, desc: "email address of the user submitting feedback"
      param :category, Feedback.feedback_categories, desc: "categorical description of the feedback", required: true
      param :content, String, desc: "the body of the feedback response", required: true
   end
 end

  api :POST, "/v1/feedback", "Submit feedback form"
  param_group :feedback_params
  def create
  	@feedback = Feedback.new(feedback_params)
		if @feedback.save
      FeedbackMailer.bug_report(@feedback).deliver if @feedback.category == "Bug Report"
      render json: 'Your report was successfully sent.'
    else
      render json: 'There was an error reporting your message'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:email, :content, :category)
    end
end