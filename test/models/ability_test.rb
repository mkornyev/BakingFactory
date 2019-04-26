require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "Within context" do
    should "verify the abilities of admin users to do everything" do
      create_admin_abilities
      assert @mark_ability.can? :manage, :all
      delete_admin_abilities
    end

    should "verify the abilities of customers" do
      create_customer_abilities
      # no global privileges
      deny @melanie_ability.can? :manage, :all
      # testing particular abilities
      deny @melanie_ability.can? :manage, ItemPrice
      assert @melanie_ability.can? :show, @honey_wheat
      assert @melanie_ability.can? :index, Item
      deny @melanie_ability.can? :create, Item
      deny @melanie_ability.can? :update, @honey_wheat
      assert @melanie_ability.can? :show, @melanie_o1
      deny @melanie_ability.can? :show, @alexe_o1
      assert @melanie_ability.can? :show, @melanie
      deny @melanie_ability.can? :show, @alexe 
      assert @melanie_ability.can? :update, @melanie
      deny @melanie_ability.can? :update, @alexe
      assert @melanie_ability.can? :show, @u_melanie
      deny @melanie_ability.can? :show, @u_alexe 
      assert @melanie_ability.can? :update, @u_melanie
      deny @melanie_ability.can? :update, @u_alexe
      assert @melanie_ability.can? :index, Order
      assert @melanie_ability.can? :checkout, Order
      assert @melanie_ability.can? :create, Order
      assert @melanie_ability.can? :add_to_cart, Order
      assert @melanie_ability.can? :create, Address
      assert @melanie_ability.can? :show, @melanie_a1
      deny @melanie_ability.can? :show, @alexe_a1
      assert @melanie_ability.can? :update, @melanie_a1
      deny @melanie_ability.can? :update, @alexe_a1
      assert @melanie_ability.can? :index, Address
      delete_customer_abilities
    end

    should "verify the abilities of baker users" do
      create_baker_abilities
      deny @baker_ability.can? :manage, :all
      assert @baker_ability.can? :show, @honey_wheat
      assert @baker_ability.can? :index, Item
      deny @baker_ability.can? :create, Item
      deny @baker_ability.can? :update, @honey_wheat
      assert @baker_ability.can? :index, Order
      deny @baker_ability.can? :show, Order
      deny @baker_ability.can? :create, Order
      deny @baker_ability.can? :update, Order
      deny @baker_ability.can? :manage, Address
      deny @baker_ability.can? :manage, ItemPrice
      delete_baker_abilities
    end

    should "verify the abilities of shipper users" do
      create_shipper_abilities
      deny @shipper_ability.can? :manage, :all
      assert @shipper_ability.can? :show, @honey_wheat
      assert @shipper_ability.can? :index, Item
      deny @shipper_ability.can? :create, Item
      deny @shipper_ability.can? :update, @honey_wheat
      assert @shipper_ability.can? :index, Order
      assert @shipper_ability.can? :show, @alexe_o1
      deny @shipper_ability.can? :create, Order
      deny @shipper_ability.can? :update, Order
      deny @shipper_ability.can? :manage, Address
      assert @shipper_ability.can? :show, @alexe_a2
      deny @shipper_ability.can? :manage, ItemPrice
      delete_shipper_abilities
    end

    should "verify the abilities of guest users to read items, become customers" do
      create_guest_abilities
      deny @guest_ability.can? :manage, :all
      assert @guest_ability.can? :show, Item
      assert @guest_ability.can? :index, Item
      assert @guest_ability.can? :create, Customer
      delete_guest_abilities
    end
  end
end