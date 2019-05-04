class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @users = User.all.paginate(page: params[:page]).per_page(10)
  end

  def new
    @user = User.new
  end

  def edit
    
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Successfully added #{@user.proper_name} as a user."
      redirect_to users_url
    else
      render action: 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated #{@user.username}."
      redirect_to users_path
    else
      render action: 'edit'
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "Successfully removed #{@user.username} from the system."
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:active, :username, :password, :password_confirmation)
    end

end
