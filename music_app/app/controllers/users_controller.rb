class UsersController < ApplicationController
    before_action :require_no_user!

    def new
        render :new
    end
    
    def show
        @users = User.find(params[:id])
        render :show
    end

    def create
        @user = User.new(user_params)

        # if user is successfully created, log them in and 
        # redirect to user index view
        if @user.save
            login!(@user)
            redirect_to users_url(@user)
        else # otherwise, unprocessable entity error
            render :new, status: 422
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password)
    end
end