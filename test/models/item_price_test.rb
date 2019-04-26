require 'test_helper'

class ItemPriceTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:item)

  # test validations with matchers
  should validate_presence_of(:item_id)
  should validate_numericality_of(:price).is_greater_than_or_equal_to(0)
  # should allow_value(Date.current).for(:start_date)
  # should allow_value(1.day.ago.to_date).for(:start_date)
  # should allow_value(1.day.from_now.to_date).for(:start_date)
  # should_not allow_value("bad").for(:start_date)
  # should_not allow_value(2).for(:start_date)
  # should_not allow_value(3.14159).for(:start_date)
  
  # should allow_value(nil).for(:end_date)
  # should_not allow_value("bad").for(:end_date)
  # should_not allow_value(2).for(:end_date)
  # should_not allow_value(3.14159).for(:end_date)

  context "Within context" do
    setup do 
      create_muffins
      create_muffin_prices
    end
    
    teardown do
      destroy_muffins
      destroy_muffin_prices
    end

    # should "check to make sure the end date is after the start date" do
    #   @bad_price = FactoryBot.build(:item_price, item: @blueberry, price: 10.95, start_date: 9.days.ago.to_date, end_date: 10.days.ago.to_date)
    #   deny @bad_price.valid?
    # end 

    should "verify that the item is active in the system" do
      @bad_price = FactoryBot.build(:item_price, item: @apple_carrot, price: 10.95)
      deny @bad_price.valid?
    end 

    should "verify that the old price end_date set to today" do
      assert_nil @bl3.end_date
      @change_price = FactoryBot.create(:item_price, item: @blueberry, price: 10.95)
      @bl3.reload
      assert_equal Date.current, @bl3.end_date
    end

    should "verify that the new price start_date set to tomorrow" do
      # assert_nil @bl3.end_date
      @change_price = FactoryBot.create(:item_price, item: @blueberry, price: 10.95)
      # @bl3.reload
      assert_equal Date.tomorrow, @change_price.start_date
    end

    should "have a working scope called current" do
      assert_equal [8.95, 9.25], ItemPrice.current.all.map(&:price).sort
    end

    should "have a working scope called chronological" do
      assert_equal [8.95, 9.25, 8.50, 8.50, 7.95, 7.95], ItemPrice.chronological.all.map(&:price)
    end

    should "have a working scope called for_date" do
      assert_equal [8.50, 8.50], ItemPrice.for_date(4.months.ago.to_date).all.map(&:price)
      assert_equal [7.95, 7.95], ItemPrice.for_date(7.months.ago.to_date).all.map(&:price)
    end

    should "have a working scope called for_item" do
      assert_equal [8.95, 8.50, 7.95], ItemPrice.for_item(@blueberry.id).all.map(&:price).sort.reverse
      assert_equal [9.25, 8.50, 7.95], ItemPrice.for_item(@chocolate_zuke.id).all.map(&:price).sort.reverse
    end

    should "correctly assess that an item_price is not destroyable" do
      deny @bl3.destroy
    end

  end
end

