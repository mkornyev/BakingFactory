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
  end

  def create
    # order_params = { customer_id: params[:customer_id], address_id: params[:address_id], grand_total: params[:grand_total] }
    @order = Order.new(order_params)
    @order.date = Date.current
    if @order.save
      @order.pay #Pay
      save_each_item_in_cart(@order) #Create order items for each order 
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'new'
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