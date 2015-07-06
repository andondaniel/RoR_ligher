class UsersController < ApplicationController

  def new
    @user = User.new_from_omniauth(session[:omniauth_user_info])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @current_user = @user
      session[:user_id] = @user.id

      redirect_to :root, notice: 'Your account was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to :root, notice: 'Your account was successfully edited.'
    else
      render 'edit'
    end
  end

  protected
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit( :email, :password, :password_confirmation,
    profile_attributes: [:id, :first_name, :last_name])
  end

end
