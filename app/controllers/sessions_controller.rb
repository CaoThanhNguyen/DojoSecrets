class SessionsController < ApplicationController
  before_action :required_login, except: [:new, :create]
  def new
    #render login page
    render "new"
  end

  def create
    user = User.find_by_email(params[:email]).try(:authenticate, params[:password]) 
    if user
      session[:user_id] = user.id
      redirect_to("/users/#{user.id}")
      return
    end
    flash[:errors] = ["Invalid email/password"]
    redirect_to("/sessions/new")
  end

  def destroy
    session[:user_id] = nil
    redirect_to("/sessions/new")
  end

  def secrets
    render "secrets"
  end
end
