class UsersController < ApplicationController
  before_filter :signed_in_user #, only: [:index, :edit, :update] #remove this only to have this limitation apply to all actions
  before_filter :correct_user,  only: [ :edit, :update]
  before_filter :admin_user,    only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id]) #removed because of the correct_user before_filter
  end
  
  def create
   @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to OC HR Tracker!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    #@user = User.find(params[:id]) #removed because of the correct_user before_filter
  end
  
  def update
    #@user = User.find(params[:id]) #removed because of the correct_user before_filter
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end
  
  private
  
    def signed_in_user
      store_location
      redirect_to signin_path, notice: "Please sign in" unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
end
