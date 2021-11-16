class UsersController < ApplicationController
    before_action :require_logged_out, only: [:new, :create]
    before_action :require_logged_in, only: [:destroy, :edit, :update, :show, :index]

    def new
        render :new
    end

    def index
        @users = User.all
        render :index
    end

    def show
        @users = User.find(params[:id])
        render :show
    end

    def create
        @user = User.new(user_params)

        if @user.save
            login!(@user)
            redirect_to user_url(@user)
        else
            render json: @user.errors.full_messages, status: 422
        end
    end

    private

    def user_params
        params.require(:user).permit(:email)
    end
end