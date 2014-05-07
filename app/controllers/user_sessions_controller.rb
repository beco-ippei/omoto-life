class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password], params[:remember])
      redirect_back_or_to :users, notice: 'Login successfull.'
    else
      @user = User.new(email: params[:email])
      flash.now[:alert] = "Login failed."
      render action: :new
    end
  end

  def destroy
    logout
    redirect_to :users, notice: 'Logged out!'
  end

  private

  def login_params     # Strong parameters
    params.require(:user)
      .permit(:email, :password, :password_confirmation, :remember)
  end
end
