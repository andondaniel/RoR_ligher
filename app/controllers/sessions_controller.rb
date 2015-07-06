class SessionsController < ApplicationController

  # workaround for adding additional identies
  skip_before_filter :verify_authenticity_token, only: :create

  def new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    omniauth_info = request.env['omniauth.auth']
    if omniauth_info
      result = UserAuthenticator.authenticate_or_create_with_omniauth(omniauth_info, current_user)
      case result[:status]
      when :new_link
        redirect_to :root, notice: "Successfully linked that account!"
      when :existing_link
        redirect_to :root, notice: "Already linked that account!"
      when :existing_user
        self.current_user = result[:user]
        redirect_to :root, notice: "Signed in!"
      when :new_user
        self.current_user = result[:user]
        redirect_to :root, notice: "Account Created!"
      end
    else
      if UserAuthenticator.authenticate_with_email?(params[:email], params[:password])
        self.current_user = User.find_by(email: params[:email])
        redirect_to :root, notice: "Logged in!"
      else
        flash.alert = "Email or password is invalid."
        render 'new'
      end
    end
  end

  def destroy
    self.current_user = nil
    session[:omniauth] = nil
    session[:omniauth_extra_raw_info] = nil
    redirect_to root_url, notice: "Signed out!"
  end

end
