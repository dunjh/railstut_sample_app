class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy
  before_action :not_valid_for_signed_in_user, only: [:new, :create]
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    user_to_delete = User.find(params[:id])
    if current_user?(user_to_delete)
      flash[:error] = "Cannot delete yourself as admin"
      redirect_to root_path
    else
      user_to_delete.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  																	:password_confirmation)
  	end

    #Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def not_valid_for_signed_in_user
      redirect_to(root_path) if signed_in?
    end
end
