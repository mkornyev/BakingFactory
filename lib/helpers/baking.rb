module AppHelpers
  module Baking
    def create_baking_list_for(category)
      # returns a hash of item name and quantity to be baked for a 
      # particular category of items like bread, muffins, etc.
      all_items = Item.for_category(category).map(&:name).sort
      baking_list = Hash[all_items.map{|name| [name, 0]}]
      unshipped_items = OrderItem.unshipped.map{|oi| [oi.item.name, oi.quantity] if all_items.include?(oi.item.name)}.compact!
      unshipped_items.each{|name, quant| baking_list[name] += quant} unless unshipped_items.nil?
      baking_list.delete_if{|key, value| value == 0}
      return baking_list
    end
  end  
end