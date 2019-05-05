class OrdersController < ApplicationController
  include AppHelpers::Cart

  before_action :set_order, only: [:show, :destroy]
  before_action :check_login
  authorize_resource
  
  def index
    @orders = Order.chronological.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @order.customer.orders.chronological.to_a
  end

  def new
    @order = Order.new
    @addresses = Address.where(customer_id: params[:customer_id])
    @customer = Customer.where(id: params[:customer_id]).take
    @customer_collection = Customer.where(id: params[:customer_id])
    @grand_total = params[:grand_total]
    # Save grand total for access in Create action
    session[:grand_total] = params[:grand_total]
  end

  def create
    # byebug
    order_params = { customer_id: params[:customer_id].values[0], address_id: params[:address_id].values[0], grand_total: session[:grand_total] }
    @order = Order.new(order_params)
    @order.date = Date.current
    @order.credit_card_number = params[:order]["credit_card_number"]
    @order.expiration_month = params[:order]["expiration_month"]
    @order.expiration_year = params[:order]["expiration_year"]
    if @order.save
      @order.pay #Pay
      save_each_item_in_cart(@order) #Create order items for each order 
      clear_cart #Clear the cart for new orders
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      redirect_to cart_path, notice: "Invalid credit card info provided. Try again."
    end
  end
  

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :grand_total)
  end

end