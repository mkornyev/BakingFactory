class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_customer, only: [:show, :edit, :update, :toggle_activity]
  before_action :check_login, except: [:new]
  authorize_resource
  
  def index
    if params[:search].present? && !(["inactive","active"].include?(params[:search]))
      @customers = Customer.all.alphabetical.search_by(params[:search]).paginate(:page => params[:page]).per_page(10)      
    # Categories
    elsif params[:search] == "active"
      @customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    elsif params[:search] == "inactive"
      @customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    else 
      @customers = Customer.all.alphabetical.paginate(:page => params[:page]).per_page(10)      
    end
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    @customer = Customer.new
    @user = @customer.build_user
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
    user = (@customer.user.nil? ? @customer.build_user : @customer.user)
  end

  def create
    @customer = Customer.new(customer_params)
    @user = User.new(customer_params.to_h.slice(:username, :password, :password_confirmation))
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
        flash[:notice] = "Customer could not be saved."
        render "customers/new"
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

  def toggle_activity
    @customer.toggle!(:active)
  end

  private
  def convert_user_role
    unless current_user.role?(:admin)
      # if you aren't admin, we are overriding the role param to be customer
      params[:customer][:user_attributes][:role] = "customer"
    end
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    convert_user_role
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, :username, :password, :password_confirmation)  
  end

end