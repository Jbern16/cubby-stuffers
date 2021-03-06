class SessionsController < ApplicationController
  def new
    session[:last_page] = request.referer
  end

  def create
    if params[:commit]
      @user = User.find_by(email: params[:session][:email])
      if @user && @user.authenticate(params[:session][:password])
        session[:user_id] = @user.id
        if current_admin?
          redirect_to admin_dashboard_path
        else
          session[:last_page] ? redirect_to(session[:last_page]) : redirect_to(login_path)
        end
      else
        flash.now[:danger] = "Invalid credentials"
        render :new
      end
    elsif request.env["omniauth.auth"]
      if @user = User.from_omniauth(request.env["omniauth.auth"])
        session[:user_id] = @user.id
        redirect_to root_path
      else
        flash[:danger] = "Invalid Github. Do you already have an account with us?"
        redirect_to login_path
      end
    else
      flash[:danger] = "Something went wrong"
      render file: "public/404"
    end
  end

  def destroy
    session.clear
    flash[:success] = "Logged out successfully!"
    redirect_to login_path
  end
end
