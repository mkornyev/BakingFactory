class OrdersController < ApplicationController
  include AppHelpers::Cart

  before_action :set_order, only: [:show, :destroy]
  before_action :check_login
  authorize_resource except: [:shipping, :add_shipping, :remove_shipping, :ship_items, :baking] 
  
  
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
      redirect_to request.referrer, notice: "Invalid credit card info provided. Try again."
    end
  end

  # Baking actions
  def baking
    if params[:search] == "bread"
      @item_quantities = Hash.new
      OrderItem.unshipped.each do |oi|
        if oi.item.category == "bread"
          if @item_quantities[oi.item_id].nil? 
            @item_quantities[oi.item_id] = oi.quantity
          else 
            @item_quantities[oi.item_id] = @item_quantities[oi.item_id] + oi.quantity
          end
        end
      end
    elsif params[:search] == "pastries"
      @item_quantities = Hash.new
      OrderItem.unshipped.each do |oi|
        if oi.item.category == "pastries"
          if @item_quantities[oi.item_id].nil? 
            @item_quantities[oi.item_id] = oi.quantity
          else 
            @item_quantities[oi.item_id] = @item_quantities[oi.item_id] + oi.quantity
          end
        end
      end
    elsif params[:search] == "muffins"
      @item_quantities = Hash.new
      OrderItem.unshipped.each do |oi|
        if oi.item.category == "muffins"
          if @item_quantities[oi.item_id].nil? 
            @item_quantities[oi.item_id] = oi.quantity
          else 
            @item_quantities[oi.item_id] = @item_quantities[oi.item_id] + oi.quantity
          end
        end
      end
    else
      @item_quantities = Hash.new
      OrderItem.unshipped.each do |oi|
        if @item_quantities[oi.item_id].nil? 
          @item_quantities[oi.item_id] = oi.quantity
        else 
          @item_quantities[oi.item_id] = @item_quantities[oi.item_id] + oi.quantity
        end
      end
    end
  end

  # Shipping actions
  def shipping 
    #Create new view vars
    @order_items = OrderItem.unshipped
    @orders = @order_items.map{ |oi| oi.order }.uniq.sort()
    # Set shipped hash if not yet set
    if session[:shipped].nil? 
      session[:shipped] = Array.new 
    end
  end

  def add_shipping
    if params[:order_item_id].present? && !session[:shipped].include?(params[:order_item_id]) 
      session[:shipped] << params[:order_item_id] 
    end
    redirect_to shipping_path, notice: "Marked item as shipped."
  end

  def remove_shipping
    if params[:order_item_id].present? && session[:shipped].include?(params[:order_item_id]) 
      session[:shipped].delete(params[:order_item_id])
    end
    redirect_to shipping_path, notice: "Unmarked item as unshipped."
  end

  def ship_items
    # If action is submit, ship items
    if params[:submit] == "true" && !session[:shipped].nil?
      session[:shipped].each do |oi_id|
        item = OrderItem.where(id: oi_id).take
        item.shipped_on = Date.today
        item.save!
      end
      # Reset boxed items 
      session[:shipped] = Array.new 
    end
    redirect_to shipping_path
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :grand_total)
  end

end