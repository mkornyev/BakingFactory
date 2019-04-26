class Ability
  include CanCan::Ability

  def initialize(user)
    # Generate a guest user if not logged in:
    user ||= User.new

    # ALL
    can :index, Item
    can :read, Item 
    can :read, ItemPrice # When displayed on the item page

    # ADMIN
    if user.role? :admin
      can :manage, :all
      
    # BAKER 
    elsif user.role? :baker 
      # Can see baking list 
      # !!!(ordered but not shipped)!!! 
      can :index, OrderItem 

    # SHIPPER
    elsif user.role? :shipper
      # Can see orders
      can :index, Order
      # and its items (ordered but not shipped) 
      can :index, OrderItem
      # along with other info
      can :read, Address 
      
    # CUSTOMER 
    elsif user.role? :customer
      # Can read item prices
      can :read, ItemPrice

      # Can view their order items
      # !!!!!!! *THEIR* !!!!!!!!
      can :read, OrderItems

      # Can manage their account settings 
      can :manage, Customer do |cust|
        user.customer == cust 
      end

      # Can add an address 
      can :create, Address  

      # Can manage their addresses 
      can :manage, Address do |addy|
        my_addresses = user.customer.addresses.map(&:id)
        my_addresses.include? addy.id 
      end

      # Can create orders 
      can :create, Order 

      # Can view their order history
      can :show, Order do |order|
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? order.id 
      end

    else
      # GUEST 
      can :create, Customer 
    end
  end
end

