module Contexts
  module Items
    # Context for items (assumes no prior contexts)
    def create_items
      create_breads
      create_muffins
      create_pastries
    end
    
    def destroy_items
      destroy_breads
      destroy_muffins
      destroy_pastries
    end

    def create_breads
      @honey_wheat = FactoryBot.create(:item, 
        name: "Honey Wheat Bread", 
        description: "Our original bread made with stone ground flour, clover honey and a lot of love. This versatile bread is great for toast, sandwiches, formal dinners and just when you need to munch.", 
        units_per_item: 1, 
        category: "bread", 
        weight: 1.0)

      @cinnamon_swirl = FactoryBot.create(:item, 
        name: "Cinnamon Swirl Bread", 
        description: "Your family will be impressed with the soft texture and appealing swirls of cinnamon in these lovely breakfast loaves.", 
        units_per_item: 1, 
        category: "bread", 
        weight: 1.0)

      @apple_cherry = FactoryBot.create(:item, 
        name: "Apple Cherry Bread", 
        description: "A delicious bread made with white flour, dried cherries and dried apples.  This yummy bread makes great holiday gifts for friends and family!", 
        units_per_item: 1, 
        category: "bread", 
        weight: 1.2,
        active: false)

      @sourdough = FactoryBot.create(:item, 
        name: "Sourdough Bread", 
        description: "It is a white bread characterized by a pronounced sourness because the dough is allowed to ferment.  Our style of sourdough is the San Francisco variety, one of the most popular in the world.  Sourdough is popular because of its ability to combine well with seafoods and soups, such as cioppino, clam chowder, and chili.", 
        units_per_item: 1, 
        category: "bread", 
        weight: 1.1)

      @challah = FactoryBot.create(:item, 
        name: "Challah Bread", 
        description: "This is a Jewish egg bread that's braided for a beautiful presentation. We top ours with poppy seeds for a special touch.", 
        units_per_item: 1, 
        category: "bread", 
        weight: 0.9)
    end

    def create_muffins
      @blueberry = FactoryBot.create(:item, 
        name: "Blueberry Muffins", 
        description: "A dozen of our most popular muffins. We use the same recipie our grandmother did to make her award-winning blueberry muffins.", 
        units_per_item: 12, 
        category: "muffins", 
        weight: 1.0)

      @chocolate_zuke = FactoryBot.create(:item, 
        name: "Chocolate Zucchini Muffins", 
        description: "A tasty recipie our mom used to make to get us to eat our veggies as often as possible with the least complaining possible. Your kids will love them too!", 
        units_per_item: 12, 
        category: "muffins", 
        weight: 1.1)

      @apple_carrot = FactoryBot.create(:item, 
        name: "Apple Carrot Muffins", 
        description: "Another recipie from mom to promote veggies in every meal.  These muffins contain fresh apple bits and shredded carrots.", 
        units_per_item: 12, 
        category: "muffins", 
        weight: 1.1,
        active: false)
    end

    def create_pastries
      @croissants = FactoryBot.create(:item, 
        name: "Crossiants", 
        description: "A staple of French cuisine, our crossiants are light, fluffy and buttery.", 
        units_per_item: 4, 
        category: "pastries", 
        weight: 1.0)
    end

    def destroy_breads
      @challah.delete
      @sourdough.delete
      @apple_cherry.delete
      @cinnamon_swirl.delete
      @honey_wheat.delete
    end

    def destroy_muffins
      @apple_carrot.delete
      @chocolate_zuke.delete
      @blueberry.delete
    end

    def destroy_pastries
      @croissants.delete
    end

  end
end