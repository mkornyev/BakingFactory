class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    @customer = Customer.new
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
  end

  def create
    @customer = Customer.new(customer_params)
    @user = User.new(user_params)
    @user.role = "customer"

    if !@user.save
      @customer.valid? 
      render action: 'new'
    else 
      @customer.user_id = @user.id
      if @customer.save 
        flash[:notice] = "Created a new customer: #{@customer.proper_name}."
        redirect_to customer_path(@customer)
      else
        render action: 'new'
      end
    end 
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end


  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, :username, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:active, :username, :password, :password_confirmation)
  end

end