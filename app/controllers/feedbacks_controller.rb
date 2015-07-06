class FeedbacksController < ApplicationController

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      FeedbackMailer.bug_report(@feedback).deliver if @feedback.category == "Bug Report"
      redirect_to :root, notice: 'Your report was successfully sent.'
    else
      flash[:notice] = 'Error reporting your message'
      render action: 'new'
    end
  end

  protected

  def feedback_params
    params.require(:feedback).permit( :email, :content, :category, :status)
  end

end
