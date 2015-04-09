class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
   @user = User.paginate(page: params[:page])
  end

  def new
   @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Video Game Replays"
      redirect_to @user
    else
      render 'new'
    end
  end


  def edit
  end

  def update
    if @user.update_attributes(user_params)
    flash[:success] = "Profile Updated"
    redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
   User.find(params[:id].destroy)
   flash[:success] = "User Deleted"
   redirect_to users_url
  end

  def show
   @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  private
   def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end

   # def signed_in_user
   # unless signed_in?
   # store_location
   # redirect_to sign_in_url, notice: "Please sign in" unless signed_in?
   # end
   # end

   def correct_user
     @user = User.find(params[:id])
     redirect_to(root_url) unless current_user?(@user)
   end

   def admin_user
     redirect_to(root_url) unless current_user.admin?
   end
end