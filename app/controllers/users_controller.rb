class UsersController < ApplicationController
    before_action :required_login, except: [:new, :create]
    
    def new 
        render "new"
    end

    def create
        @user = User.create(name:params[:name], email:params[:email], 
                password:params[:password], password_confirmation:params[:password_confirmation])
        if @user.valid?
            session[:user_id] = @user.id
            redirect_to("/users/#{@user.id}")
            return
        end
        flash_errors(@user)
        redirect_to("/users/new")
    end

    def show
        if is_allowed(params[:user_id].to_i)
            @user = User.find(id=session[:user_id])
            @secrets = @user.secrets 
            render "show"
        end
    end

    def edit
        if is_allowed(params[:user_id].to_i)
            @user = User.find(params[:user_id])
            render "edit"
        end
    end

    def update
        if is_allowed(params[:user_id].to_i)
            @user = User.find(id=params[:user_id])
            @user.update(name: params[:name], email: params[:email])
            if @user.valid?
                @user.save
                redirect_to("/users/#{@user.id}")
                return
            end
            flash_errors(@user)
            redirect_to("/users/#{params[:user_id]}/edit")
        end
    end

    def destroy
        if is_allowed(params[:user_id].to_i)
            User.find(id=params[:user_id]).destroy
            # clear the session
            session[:user_id] = nil
            redirect_to("/users/new")
        end
    end
end
