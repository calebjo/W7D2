class SessionsController < ApplicationController
    before_action :require_logged_out, only: [:new, :create]
    before_action :require_logged_in, only: [:destroy]

    def new
        render :new
    end

    def create
        # create a session with user's params
        @user = User.find_by_credentials(
            params[:user][:email],
            params[:user][:password]
        )
        debugger
        # if user is created successfully, log them in and redirect
        if @user.save
            login!(@user)
            redirect_to users_url(@user) # UsersController#show
        else # otherwise try again
            render :new
        end
    end

    def destroy
        logout!
        redirect_to new_sesson_url
    end
end