class UsersController < ApplicationController
    before_action :require_logged_out, only: [:new, :create]
    before_action :require_logged_in, only: [:index, :show]

    def index
        @users = User.all
        render :index
    end

    def new
        @user = User.new
        render :new
    end

    def show
        @user = current_user
        render :show
    end

    def create
        @user = User.new(user_params)

        if @user.save
            login(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password)
    end
end
