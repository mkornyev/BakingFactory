module Populator
  module Items
    def create_breads_and_prices
      honey_wheat = FactoryBot.create(:item, 
        name: "Honey Wheat Bread", 
        description: "Our original bread made with stone ground flour, clover honey and a lot of love. This versatile bread is great for toast, sandwiches, formal dinners and just when you need to munch.", 
        units_per_item: 1, 
        category: "bread", 
        weight: 1.0)
      # prices
      hw1 = FactoryBot.create(:item_price, item: honey_wheat, price: 3.95, start_date: 24.months.ago.to_date)
      hw1.update_attribute(:start_date, 24.months.ago.to_date)
      hw2 = FactoryBot.create(:item_price, item: honey_wheat, price: 4.25, start_date: 14.months.ago.to_date)
      hw2.update_attribute(:start_date, 14.months.ago.to_date)
      hw1.update_attribute(:end_date, 14.months.ago.to_date - 1)
      hw3 = FactoryBot.create(:item_price, item: honey_wheat, price: 4.75, start_date: 42.weeks.ago.to_date)
      hw3.update_attribute(:start_date, 42.weeks.ago.to_date)
      hw2.update_attribute(:end_date, 42.weeks.ago.to_date - 1)
      hw4 = FactoryBot.create(:item_price, item: honey_wheat, price: 4.95, start_date: 6.months.ago.to_date)
      hw4.update_attribute(:start_date, 6.months.ago.to_date)
      hw3.update_attribute(:end_date, 6.months.ago.to_date - 1)
      hw5 = FactoryBot.create(:item_price, item: honey_wheat, price: 5.25, start_date: 4.weeks.ago.to_date)
      hw5.update_attribute(:start_date, 4.weeks.ago.to_date)
      hw4.update_attribute(:end_date, 4.weeks.ago.to_date - 1)
  
      cinnamon_swirl = FactoryBot.create(:item, 
          name: "Cinnamon Swirl Bread", 
          description: "Your family will be impressed with the soft texture and appealing swirls of cinnamon in these lovely breakfast loaves.", 
          units_per_item: 1, 
          category: "bread", 
          weight: 1.0)
      # prices
      cs1 = FactoryBot.create(:item_price, item: cinnamon_swirl, price: 4.25, start_date: 24.months.ago.to_date)
      cs1.update_attribute(:start_date, 24.months.ago.to_date)
      cs2 = FactoryBot.create(:item_price, item: cinnamon_swirl, price: 4.75, start_date: 13.months.ago.to_date)
      cs2.update_attribute(:start_date, 13.months.ago.to_date)
      cs1.update_attribute(:end_date, 13.months.ago.to_date - 1)
      cs3 = FactoryBot.create(:item_price, item: cinnamon_swirl, price: 4.95, start_date: 180.days.ago.to_date)
      cs3.update_attribute(:start_date, 180.days.ago.to_date)
      cs2.update_attribute(:end_date, 180.days.ago.to_date - 1)
      cs4 = FactoryBot.create(:item_price, item: cinnamon_swirl, price: 5.50, start_date: 3.weeks.ago.to_date)
      cs4.update_attribute(:start_date, 3.weeks.ago.to_date)
      cs3.update_attribute(:end_date, 3.weeks.ago.to_date - 1)

      apple_cherry = FactoryBot.create(:item, 
          name: "Apple Cherry Bread", 
          description: "A delicious bread made with white flour, dried cherries and dried apples.  This yummy bread makes great holiday gifts for friends and family!", 
          units_per_item: 1, 
          category: "bread", 
          weight: 1.2)
      # prices
      ac1 = FactoryBot.create(:item_price, item: apple_cherry, price: 4.95, start_date: 12.months.ago.to_date)
      ac1.update_attribute(:start_date, 12.months.ago.to_date)
      ac2 = FactoryBot.create(:item_price, item: apple_cherry, price: 5.95, start_date: 6.months.ago.to_date)
      ac2.update_attribute(:start_date, 6.months.ago.to_date)
      ac1.update_attribute(:end_date, 6.months.ago.to_date - 1)
      ac3 = FactoryBot.create(:item_price, item: apple_cherry, price: 6.95, start_date: 2.weeks.ago.to_date)
      ac3.update_attribute(:start_date, 2.weeks.ago.to_date)
      ac2.update_attribute(:end_date, 2.weeks.ago.to_date - 1)
  
      sourdough = FactoryBot.create(:item, 
          name: "Sourdough Bread", 
          description: "It is a white bread characterized by a pronounced sourness because the dough is allowed to ferment.  Our style of sourdough is the San Francisco variety, one of the most popular in the world.  Sourdough is popular because of its ability to combine well with seafoods and soups, such as cioppino, clam chowder, and chili.", 
          units_per_item: 1, 
          category: "bread", 
          weight: 1.1)
      # prices
      sd1 = FactoryBot.create(:item_price, item: sourdough, price: 4.25, start_date: 24.months.ago.to_date)
      sd1.update_attribute(:start_date, 24.months.ago.to_date)
      sd2 = FactoryBot.create(:item_price, item: sourdough, price: 4.75, start_date: 13.months.ago.to_date)
      sd2.update_attribute(:start_date, 13.months.ago.to_date)
      sd1.update_attribute(:end_date, 13.months.ago.to_date - 1)
      sd3 = FactoryBot.create(:item_price, item: sourdough, price: 4.95, start_date: 180.days.ago.to_date)
      sd3.update_attribute(:start_date, 180.days.ago.to_date)
      sd2.update_attribute(:end_date, 180.days.ago.to_date - 1)
      sd4 = FactoryBot.create(:item_price, item: sourdough, price: 5.50, start_date: 3.weeks.ago.to_date)
      sd4.update_attribute(:start_date, 3.weeks.ago.to_date)
      sd3.update_attribute(:end_date, 3.weeks.ago.to_date - 1)
  
      challah = FactoryBot.create(:item, 
          name: "Challah Bread", 
          description: "This is a Jewish egg bread that's braided for a beautiful presentation. We top ours with poppy seeds for a special touch.", 
          units_per_item: 1, 
          category: "bread", 
          weight: 0.9)
      # prices
      ch1 = FactoryBot.create(:item_price, item: challah, price: 4.95, start_date: 14.months.ago.to_date)
      ch1.update_attribute(:start_date, 14.months.ago.to_date)
      ch2 = FactoryBot.create(:item_price, item: challah, price: 5.50, start_date: 6.months.ago.to_date)
      ch2.update_attribute(:start_date, 6.months.ago.to_date)
      ch1.update_attribute(:end_date, 6.months.ago.to_date - 1)
      ch3 = FactoryBot.create(:item_price, item: challah, price: 5.75, start_date: 14.days.ago.to_date)
      ch3.update_attribute(:start_date, 14.days.ago.to_date)
      ch2.update_attribute(:end_date, 14.days.ago.to_date - 1)
    end


    def create_muffins_and_prices
      blueberry = FactoryBot.create(:item, 
        name: "Blueberry Muffins", 
        description: "A dozen of our most popular muffins. We use the same recipie our grandmother did to make her award-winning blueberry muffins.", 
        units_per_item: 12, 
        category: "muffins", 
        weight: 1.0)
      # prices
      bl1 = FactoryBot.create(:item_price, item: blueberry, price: 7.95, start_date: 12.months.ago.to_date)
      bl1.update_attribute(:start_date, 12.months.ago.to_date)
      bl2 = FactoryBot.create(:item_price, item: blueberry, price: 8.50, start_date: 6.months.ago.to_date)
      bl2.update_attribute(:start_date, 6.months.ago.to_date)
      bl1.update_attribute(:end_date, 6.months.ago.to_date - 1)
      bl3 = FactoryBot.create(:item_price, item: blueberry, price: 8.95, start_date: 1.week.ago.to_date)
      bl3.update_attribute(:start_date, 1.week.ago.to_date)
      bl2.update_attribute(:end_date, 1.week.ago.to_date - 1)
      
      chocolate_zuke = FactoryBot.create(:item, 
        name: "Chocolate Zucchini Muffins", 
        description: "A tasty recipie our mom used to make to get us to eat our veggies as often as possible with the least complaining possible. Your kids will love them too!", 
        units_per_item: 12, 
        category: "muffins", 
        weight: 1.1)
      # prices
      cz1 = FactoryBot.create(:item_price, item: chocolate_zuke, price: 7.95, start_date: 12.months.ago.to_date)
      cz1.update_attribute(:start_date, 12.months.ago.to_date)
      cz2 = FactoryBot.create(:item_price, item: chocolate_zuke, price: 8.50, start_date: 6.months.ago.to_date)
      cz2.update_attribute(:start_date, 6.months.ago.to_date)
      cz1.update_attribute(:end_date, 6.months.ago.to_date - 1)
      cz3 = FactoryBot.create(:item_price, item: chocolate_zuke, price: 9.25, start_date: 2.weeks.ago.to_date)
      cz3.update_attribute(:start_date, 2.weeks.ago.to_date)
      cz2.update_attribute(:end_date, 2.weeks.ago.to_date - 1)
  
      apple_carrot = FactoryBot.create(:item, 
        name: "Apple Carrot Muffins", 
        description: "Another recipie from mom to promote veggies in every meal.  These muffins contain fresh apple bits and shredded carrots.", 
        units_per_item: 12, 
        category: "muffins", 
        weight: 1.1)
      # prices
      ca1 = FactoryBot.create(:item_price, item: apple_carrot, price: 7.95, start_date: 12.months.ago.to_date)
      ca1.update_attribute(:start_date, 12.months.ago.to_date)
      ca2 = FactoryBot.create(:item_price, item: apple_carrot, price: 8.50, start_date: 6.months.ago.to_date)
      ca2.update_attribute(:start_date, 6.months.ago.to_date)
      ca1.update_attribute(:end_date, 6.months.ago.to_date - 1)
      ca3 = FactoryBot.create(:item_price, item: apple_carrot, price: 8.95, start_date: 2.weeks.ago.to_date)  
      ca3.update_attribute(:start_date, 2.weeks.ago.to_date)
      ca2.update_attribute(:end_date, 2.weeks.ago.to_date - 1)
    end


    def create_pastries_and_prices
      croissants = FactoryBot.create(:item, 
        name: "Crossiants", 
        description: "A staple of French cuisine, our crossiants are light, fluffy and buttery.", 
        units_per_item: 4, 
        category: "pastries", 
        weight: 1.0)
      # price
      cr1 = FactoryBot.create(:item_price, item: croissants, price: 9.50, start_date: 6.months.ago.to_date)      
      cr1.update_attribute(:start_date, 6.months.ago.to_date)
    end
  end
end



