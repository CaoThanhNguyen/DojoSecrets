require "application_helper"
class SecretsController < ApplicationController
  before_action :required_login
  def index
    @secrets = Secret.all
    render "index"
  end

  def create
    if is_allowed(params[:user_id].to_i)
      @user = User.find(id=session[:user_id]) 
      @secret = Secret.new(content:params[:content], user:@user)
      if @secret.valid?
        @secret.save
        redirect_to("/users/#{@user.id}")
        return
      end
      flash_errors @user
      redirect_to("/users/#{@user.id}")
    end
  end

  def like
    if is_allowed(params[:user_id].to_i)
      @secret = Secret.find(id=params[:secret_id])
      @user = User.find(id=params[:user_id])
      @like = Like.create(secret:@secret, user:@user)
      @users_like = @secret.users_like
      # puts @users_like.inspect
      redirect_to("/secrets")
    end
  end

  def unlike
    if is_allowed(params[:user_id].to_i)
      @secret = Secret.find(id=params[:secret_id])
      @user = User.find(id=params[:user_id])
      @likes = Like.where(user:@user, secret:@secret).destroy_all
      redirect_to("/secrets")
    end
  end

  def destroy
    if is_allowed(params[:user_id].to_i)
      # check if this secret belongs to this user
      @user = User.find(id=params[:user_id])
      @secret = Secret.find(id=params[:secret_id])
      if @secret.user != @user 
        flash[:errors] = ["Permission denied!"]
        redirect_to("/sessions/new")
        return
      end
      @secret.destroy
      redirect_to("/users/#{session[:user_id]}")
    end
  end

end
