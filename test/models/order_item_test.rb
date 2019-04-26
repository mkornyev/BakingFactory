require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:order)
  should belong_to(:item)

  # test simple validations with matchers
  should validate_presence_of(:item_id)
  should validate_presence_of(:order_id)
  should validate_numericality_of(:quantity).only_integer.is_greater_than(0)
  should allow_value(Date.current).for(:shipped_on)
  should allow_value(1.day.ago.to_date).for(:shipped_on)
  should allow_value(1.day.from_now.to_date).for(:shipped_on)
  should_not allow_value("bad").for(:shipped_on)
  should_not allow_value(2).for(:shipped_on)
  should_not allow_value(3.14159).for(:shipped_on)
 
   context "Within context" do
    setup do 
      create_breads
      create_bread_prices
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_order_items
    end
    
    teardown do
      destroy_breads
      destroy_bread_prices
      destroy_customer_users
      destroy_customers
      destroy_addresses
      destroy_orders
      destroy_order_items
    end

    should "verify that the item is active in the system" do
      @bad_order_item = FactoryBot.build(:order_item, order: @ryan_o1, item: @apple_cherry)
      deny @bad_order_item.valid?
    end 

    should "have a method which calculates the subtotal for current date" do
      assert_equal 5.50, @melanie_o1_1.subtotal
      assert_equal (5.75*3), @alexe_o3_2.subtotal
    end

    should "have a method which calculates the subtotal for a past date" do
      assert_equal 4.75, @melanie_o1_1.subtotal(1.year.ago.to_date)
    end

    should "return nil for a subtotal for a future date" do
      assert_nil @melanie_o1_1.subtotal(1.year.from_now.to_date)
    end

    should "have a working scope called shipped" do
      assert_equal 3, OrderItem.shipped.count
    end

    should "have a working scope called unshipped" do
      assert_equal 7, OrderItem.unshipped.count    
    end    

  end
end