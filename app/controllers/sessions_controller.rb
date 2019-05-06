class SessionsController < ApplicationController
  include AppHelpers::Cart

  def new
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      
      #Set up cart for customers and admins 
      if ["admin","customer"].include? user.role
        create_cart 
      end

      if ( current_user.role?(:shipper) )
        redirect_to shipping_path, notice: "Logged in!"
      elsif ( current_user.role?(:baker) )
        redirect_to baking_path, notice: "Logged in!"
      else
        redirect_to home_path, notice: "Logged in!"
      end
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    # Delete cart upon logout
    user = User.where(id: current_user.id).take
    unless user.nil? 
      if ["admin","customer"].include? user.role
        destroy_cart
      end
    end

    session[:user_id] = nil
    redirect_to home_path, notice: "Logged out!"
  end
end