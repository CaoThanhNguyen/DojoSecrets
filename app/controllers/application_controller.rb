class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  def flash_errors obj
      flash[:errors] = []
      error_messages = obj.errors.messages
      error_messages.each do |key, list_of_errors|
          for error in list_of_errors
              flash[:errors].push("#{key} #{error}")
          end 
      end
  end
  def required_login
    if session[:user_id] == nil
      flash[:errors] = ["You need to login first"]
      redirect_to("/sessions/new")
      return
    end
  end
  def is_allowed user_id
      if session[:user_id] != user_id
          flash[:errors] = ["Permission denied!"]
          redirect_to "/sessions/new"
          return false
      end
      return true
  end

  helper_method :current_user, :flash_errors, :required_login, :is_allowed
end
