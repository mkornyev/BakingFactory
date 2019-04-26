module Contexts
  module Abilities
    # Admins
    def create_admin_abilities
      @mark_user = FactoryBot.create(:user, username: "mark", role: "admin")
      @mark_ability = Ability.new(@mark_user)
    end

    def delete_admin_abilities
      @mark_user.delete
    end

    # Customers
    def create_customer_abilities
      # created related objects for testing
      create_breads
      create_bread_prices
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_order_items
      # make the melanie ability using the melanie user
      @melanie_ability = Ability.new(@u_melanie)
    end

    def delete_customer_abilities
      destroy_order_items
      destroy_orders
      destroy_addresses
      destroy_customers
      destroy_customer_users
      destroy_bread_prices
      destroy_breads
    end

    # Bakers and shippers
    def create_baker_abilities
      @baker_user = FactoryBot.create(:user, username: "baker", role: "baker")
      @baker_ability = Ability.new(@baker_user)
      # created related objects for testing
      create_breads
      create_bread_prices
    end

    def delete_baker_abilities
      @baker_user.delete
      destroy_bread_prices
      destroy_breads
    end

    def create_shipper_abilities
      @shipper_user = FactoryBot.create(:user, username: "shipper", role: "shipper")
      @shipper_ability = Ability.new(@shipper_user)
      # created related objects for testing
      create_breads
      create_bread_prices
      create_customer_users
      create_customers
      create_addresses
      create_orders
      create_order_items
    end

    def delete_shipper_abilities
      @shipper_user.delete
      destroy_order_items
      destroy_orders
      destroy_addresses
      destroy_customers
      destroy_customer_users
      destroy_bread_prices
      destroy_breads
    end

    # Guests
    def create_guest_abilities
      @guest_user = User.new
      @guest_ability = Ability.new(@guest_user)
    end

    def delete_guest_abilities
      # nothing to delete, b/c nothing saved to db
    end

  end
end