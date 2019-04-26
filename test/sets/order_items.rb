module Contexts
  module OrderItems
    # Context for order_items (assumes item, order contexts plus contexts associated with order)
    def create_order_items
      @alexe_o1_1   = FactoryBot.create(:order_item, order: @alexe_o1, item: @honey_wheat, quantity: 1, shipped_on: 4.days.ago.to_date)
      @alexe_o2_1   = FactoryBot.create(:order_item, order: @alexe_o2, item: @honey_wheat, quantity: 1, shipped_on: 2.days.ago.to_date)
      @alexe_o3_1   = FactoryBot.create(:order_item, order: @alexe_o3, item: @honey_wheat, quantity: 4)
      @alexe_o3_2   = FactoryBot.create(:order_item, order: @alexe_o3, item: @challah, quantity: 3)
      @melanie_o1_1 = FactoryBot.create(:order_item, order: @melanie_o1, item: @cinnamon_swirl, quantity: 1, shipped_on: 3.days.ago.to_date)
      @melanie_o2_1 = FactoryBot.create(:order_item, order: @melanie_o2, item: @cinnamon_swirl, quantity: 1)
      @anthony_o1_1 = FactoryBot.create(:order_item, order: @anthony_o1, item: @challah, quantity: 1)
      @anthony_o1_2 = FactoryBot.create(:order_item, order: @anthony_o1, item: @honey_wheat, quantity: 1)
      @anthony_o1_3 = FactoryBot.create(:order_item, order: @anthony_o1, item: @sourdough, quantity: 1)
      @ryan_o1_1    = FactoryBot.create(:order_item, order: @ryan_o1, item: @sourdough, quantity: 2)
    end
    
    def destroy_order_items
      @alexe_o1_1.delete
      @alexe_o2_1.delete
      @alexe_o3_1.delete
      @alexe_o3_2.delete
      @melanie_o1_1.delete
      @melanie_o2_1.delete
      @anthony_o1_1.delete
      @anthony_o1_2.delete
      @anthony_o1_3.delete
      @ryan_o1_1.delete
    end

  end
end