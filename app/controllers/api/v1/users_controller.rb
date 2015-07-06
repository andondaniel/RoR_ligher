class API::V1::UsersController < API::V1::ApplicationController
  respond_to :xml, :json

  before_action :set_user, only: [:show, :update, :destroy]
  before_action :token_authenticate, except: [:authenticate, :create, :authenticate_or_create_with_omniauth]

  #skips csrf check
  skip_before_filter :verify_authenticity_token

  resource_description do
    short "Spylight Users"
    formats ['json']
    description ""
  end

  def_param_group :profile_params do
    param :profile_attributes, Hash do
      param :first_name, String, desc: "A user's first name"
      param :last_name, String,  desc: "A user's last name"
    end
  end

  def_param_group :user_params do
    param :user, Hash do
      param :email, String, desc: "Users's E-mail address"
      param :password, String, desc: "User's password"
      param :password_confirmation, String, desc: "Confirmation of user's password"
      param_group :profile_params
    end
  end

  def_param_group :omniauth_info_params do
    param :info, Hash do
      param :first_name, String, desc: "first name from info node of OAuth response"
      param :last_name, String, desc: "last name from info node of OAuth response"
      param :email, String, desc: "email from info node of OAuth response"
    end
  end

  def_param_group :omniauth_params do
    param :omniauth_info, Hash do
      param :uid, String, desc: "User Identification provided by omniauth"
      param :provider, String, desc: "omniauth provider"
      param_group :omniauth_info_params
    end
  end

  def_param_group :auth_params do
    param :email, String, desc: "User's email address"
    param :password, String, desc: "User's password"
  end


  api :POST, "/v1/users/", "Creates a user via email and password."
  description "Used to create a user. If user is successfully create a hexadecimal auth_token will be returned."
  param_group :user_params
  def create
    @user = User.new(user_params)
    if @user.save
      @user.set_auth_token unless @user.auth_token
      render text: @user.auth_token
    else
      if User.find_by(email: @user.email)
        render json: "Email already taken"
      elsif @user.password != @user.password_confirmation
        render json: "Passwords must match"
      else
        render json: "User was unable to be saved"
      end
    end
  end

  api :POST, "v1/users/authenticate", "Authenticate a user, returning user auth token"
  description "Use to authenticate a user using email/pw. If login is successful, store hexadecimal auth_token to access other user specific features."
  param_group :auth_params
  def authenticate
    if UserAuthenticator.authenticate_with_email?(params[:email], params[:password])
      user = User.find_by(email: params[:email])
      user.set_auth_token unless user.auth_token
      render text: user.auth_token
    else
      render text: "invalid user/password"
    end
  end

  api :POST, "v1/users/authenticate_or_create_with_omniauth", "Authenticate or create a user via omniauth, returning user auth token"
  description "Use to authenticate a user using OAuth. If login is successful, store hexadecimal auth_token to access other user specific features."
  param_group :omniauth_params
  def authenticate_or_create_with_omniauth
    omniauth_info = params[:omniauth_info]
    if omniauth_info
      result = UserAuthenticator.authenticate_or_create_with_omniauth(omniauth_info)
      handle_omniauth_result(result)
    else
      render json: "must provide omniauth_info"
    end
  end

  api :GET, "/v1/users", "Lists all users"
  description "Returns an Array of all registered Spylight users"
  def index
    @users = User.all
    respond_with @users
  end

  api :GET, "/v1/users/:id", "Fetches details of a specific user"
  description "Returns a JSON node with name 'user' that contains the user's name, id, email, and address"
  def show
    respond_with @user
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  #Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit( :email, :password, :password_confirmation, profile_attributes: [:first_name, :last_name])
  end


  def identity_params
    params.require(:identity).permit(:uid, :provider)
  end

  def handle_omniauth_result(result)
    if result[:success]
      user = result[:user]
      user.set_auth_token unless user.auth_token
      case result[:status]
      when :new_link
        render text: user.auth_token
      when :existing_link
        render text: user.auth_token
      when :existing_user
        render text: user.auth_token
      when :new_user
        render text: user.auth_token
      end
    else
      render text: "error authenticating with omniauth!"
    end
  end

end
