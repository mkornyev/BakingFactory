require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test relationships
  should have_many(:order_items)
  should have_many(:item_prices)
  should have_many(:orders).through(:order_items)

  # test validations with matchers
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).case_insensitive
  should validate_numericality_of(:units_per_item).only_integer.is_greater_than(0)
  should validate_numericality_of(:weight).is_greater_than(0)
  # should validate_inclusion_of(:category).in_array(Item::CATEGORIES.to_h.values)
  should validate_inclusion_of(:category).in_array(%w[bread muffins pastries])

  # not necessary, but don't hurt...
  should allow_value(10).for(:units_per_item)
  should allow_value(10).for(:weight)
  should allow_value(10.5).for(:weight)

  should_not allow_value(-10).for(:units_per_item)
  should_not allow_value(-10).for(:weight)
  should_not allow_value(10.5).for(:units_per_item)
  should_not allow_value(0).for(:units_per_item)
  should_not allow_value(0).for(:weight)

  # set up context
  context "Within context" do
    setup do 
      create_muffins
    end
    
    teardown do
      destroy_muffins
    end

    should "show that there are three items in in alphabetical order" do
      assert_equal ["Apple Carrot Muffins", "Blueberry Muffins", "Chocolate Zucchini Muffins"], Item.alphabetical.all.map(&:name)
    end

    should "show that there are two active items and one inactive item" do
      assert_equal ["Blueberry Muffins", "Chocolate Zucchini Muffins"], Item.active.all.map(&:name).sort
      assert_equal ["Apple Carrot Muffins"], Item.inactive.all.map(&:name).sort
    end

    should "show that there is a working for_category scope" do
      create_pastries
      assert_equal ["Apple Carrot Muffins", "Blueberry Muffins", "Chocolate Zucchini Muffins"], Item.for_category('muffins').all.map(&:name).sort
      assert_equal ["Crossiants"], Item.for_category('pastries').all.map(&:name).sort
      # destroy_pastries
    end

    should "return correct current price" do
      create_muffin_prices
      assert_equal 9.25, @chocolate_zuke.current_price
      assert_equal 8.95, @blueberry.current_price
      # destroy_muffin_prices
    end

    should "return correct price for past date" do
      create_muffin_prices
      assert_equal 7.95, @chocolate_zuke.price_on_date(8.months.ago.to_date)
      assert_equal 8.50, @blueberry.price_on_date(4.months.ago.to_date)
      # destroy_muffin_prices
    end

    should "show that an item that has been shipped cannot be destroyed" do
      create_breads
      create_bread_prices
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_order_items
      @honey_wheat.destroy
      deny @honey_wheat.destroyed?
      # destroy_breads
      # destroy_bread_prices
      # destroy_customer_users
      # destroy_customers
      # destroy_addresses
      # destroy_orders
      # destroy_order_items
    end

    should "show that an item that has never shipped can be destroyed" do
      create_breads
      create_bread_prices
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_order_items
      @blueberry.destroy
      assert @blueberry.destroyed?
      # destroy_breads
      # destroy_bread_prices
      # destroy_customer_users
      # destroy_customers
      # destroy_addresses
      # destroy_orders
      # destroy_order_items
    end

    should "show that a destroyed item is not part of unshipped, unpaid orders" do
      create_breads
      create_bread_prices
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_order_items
      extra_item = FactoryBot.create(:order_item, order: @ryan_o1, item: @blueberry, quantity: 1)
      assert_equal 2, @ryan_o1.order_items.count
      @blueberry.destroy
      assert @blueberry.destroyed?
      @ryan_o1.reload
      # the blueberry muffins should be deleted from Ryan's order items
      assert_equal 1, @ryan_o1.order_items.count
      # destroy_breads
      # destroy_bread_prices
      # destroy_customer_users
      # destroy_customers
      # destroy_addresses
      # destroy_orders
      # destroy_order_items
    end

    should "make an improperly destroyed item inactive" do
      create_breads
      create_bread_prices
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_order_items
      assert @cinnamon_swirl.active
      assert_equal 2, @cinnamon_swirl.order_items.count
      assert_equal 1, @cinnamon_swirl.order_items.unshipped.count
      @cinnamon_swirl.destroy
      # check that it is now inactive
      deny @cinnamon_swirl.active
      # check that we have removed the unshipped order, but not the shipped one
      assert_equal 1, @cinnamon_swirl.order_items.count
      # destroy_breads
      # destroy_bread_prices
      # destroy_customer_users
      # destroy_customers
      # destroy_addresses
      # destroy_orders
      # destroy_order_items
    end

    should "not make inactive because of an improper edit" do
      assert @blueberry.active
      @blueberry.name = nil
      deny @blueberry.valid?
      # try to save the invalid record; see that it is not saved (rollback)
      deny @blueberry.save
      # verify that the rollback did not make the address inactive
      assert @blueberry.active
    end

    should "have make_active and make_inactive methods" do
      assert @blueberry.active
      @blueberry.make_inactive
      @blueberry.reload
      deny @blueberry.active
      @blueberry.make_active
      @blueberry.reload
      assert @blueberry.active
    end

  end
end
