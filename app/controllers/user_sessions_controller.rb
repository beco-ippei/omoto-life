class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  def new
    @user = User.new
    session[:return_to_url] = session[:previous_url]
  end

  def create
    if @user = login(params[:email], params[:password], params[:remember])
      redirect_back_or_to :root, notice: 'ログインしました'
      session[:return_to_url] = nil
    else
      @user = User.new(email: params[:email])
      flash.now[:alert] = "ログインできません。メールアドレスかパスワードが間違っています"
      render action: :new
    end
  end

  def destroy
    logout
    redirect_to :root, notice: 'ログアウトしました'
  end

  private

  def login_params     # Strong parameters
    params.require(:user)
      .permit(:email, :password, :password_confirmation, :remember)
  end
end
