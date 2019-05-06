class CartItemsController < ApplicationController
	include AppHelpers::Cart
	include AppHelpers::Shipping

	def show
		@order_items = get_list_of_items_in_cart
		@subtotal = calculate_cart_items_cost
		@shipping = calculate_cart_shipping
		@customer = Customer.where(user_id: current_user.id).take
		@addresses = Address.where(customer_id: @customer.id).all
	end

	def add_item
		add_item_to_cart(params[:item_id])

		path_var = request.referrer.split("/").last
		if path_var == "items" || path_var.include?("page")
			redirect_to items_path
		else 
			redirect_to item_path(Item.where(id: path_var).take)
		end
	end

	def remove_item
		remove_item_from_cart(params[:item_id])
		redirect_to cart_path
	end

	def clear 
		clear_cart
		redirect_to cart_path
	end 

	def place_order
		#Create order first 
		order_params = { customer_id: params[:customer_id], address_id: params[:address_id], grand_total: params[:grand_total] }
    	@order = Order.new( order_params )
	    @order.date = Date.current
	    if @order.save
	      @order.pay #Pay
	      save_each_item_in_cart(@order) #Create order items for each order 
	      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
	    else
	      render action: 'new'
	    end
    end

end