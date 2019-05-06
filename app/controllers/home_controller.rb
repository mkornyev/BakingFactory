
class HomeController < ApplicationController

  def home
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def sales_dash
  	# Total goods 
  	order_item_hash = Hash.new
  	OrderItem.all.each do |oi|
  		if order_item_hash[oi.item_id].nil?
  			order_item_hash[oi.item_id] = oi.quantity
  		else
  			order_item_hash[oi.item_id] = order_item_hash[oi.item_id] + oi.quantity
  		end
  	end 
  	@goods_count = order_item_hash.values.sum 

  	# Total sales 
  	@total_sales = Order.all.map{|o| o.grand_total}.sum

  	# Earliest order (weeks ago)
  	@weeks = TimeDifference.between(Order.order(:date).first.date, Time.now).in_weeks.floor

  	# Looks back X weeks to find orders
  	if params[:weeks].present? 
  		@orders = sales_chart_data(params[:weeks].to_i)  		
  	else
		@orders = sales_chart_data(@weeks)  		
  	end
  	
  end

  def sales_chart_data(week_count)
  	# Sales for each day 
  	(week_count.weeks.ago.to_date..Date.today).map do |date|
  		{
  		date: date.strftime('%F'), 
  		sales: Order.where(date: date).sum(:grand_total)
  		}
  	end
  end

  def customer_dash
  	# Total Customers
  	@customer_count = Customer.all.count 
  	@active_customer_count = Customer.all.active.count 
  	@avg_address_count = ((Address.all.count) / (@customer_count))
  	@avg_address_count = @avg_address_count.floor
  	@customers = customer_chart_data
  	@customers = @customers.sort_by{ |arr| arr[:value] }
  end

  def customer_chart_data
  	# Customer order counts
  	(Customer.all).map do |c|
  		{
  		label: c.name,
  		value: Order.where(customer_id: c.id).size
  		}
  	end
  end

  def item_dash
  	# Total Items
  	@item_count = Item.all.count 
  	@active_item_count = Item.all.active.count 
  	@items = item_chart_data
  	@items = @items.sort_by{ |arr| arr[:value] }
  end

  def item_chart_data
  	# Customer order counts
  	(Item.all).map do |i|
  		{
  		label: i.name,
  		value: OrderItem.where(item_id: i.id).map{|oi| oi.quantity}.sum
  		}
  	end
  end

end