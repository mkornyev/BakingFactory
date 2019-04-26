require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:customer)
  should have_many(:orders)

  # test validations with matchers
  should validate_presence_of(:recipient)
  should validate_presence_of(:street_1)
  # should validate_inclusion_of(:state).in_array(Address::STATES_LIST.to_h.values)
  should validate_inclusion_of(:state).in_array(["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"])
  
  should allow_value("12345").for(:zip)
  should_not allow_value("1234").for(:zip)
  should_not allow_value("123456").for(:zip)
  should_not allow_value("12345-0001").for(:zip)
  should_not allow_value("1234I").for(:zip)
  should_not allow_value(nil).for(:zip)

  context "Within context" do
    setup do 
      create_customer_users
      create_customers
      create_addresses
    end
    
    teardown do
      # destroy_customer_users
      # destroy_customers
      # destroy_addresses
    end

    should "show that by_recipient places addresses in alphabetical order" do
      assert_equal ["Alex Egan", "Anthony Corletti", "Jeff Egan", "Melanie Freeman", "Ryan Flood", "Zach Egan"], Address.by_recipient.all.map(&:recipient)
    end

    should "show that by_customer places addresses in alphabetical order by customer" do
      assert_equal ["Anthony Corletti", "Alex Egan", "Jeff Egan", "Zach Egan", "Ryan Flood", "Melanie Freeman"], Address.by_customer.by_recipient.all.map(&:recipient)
    end

    should "show that there are two active addresses and one inactive address" do
      assert_equal 5, Address.active.all.count
      assert_equal ["Zach Egan"], Address.inactive.all.map(&:recipient).sort
    end

    should "show that scopes for billing and shipping" do
      assert_equal ["Alex Egan", "Anthony Corletti", "Melanie Freeman", "Ryan Flood"], Address.billing.all.map(&:recipient).sort
      assert_equal ["Jeff Egan", "Zach Egan"], Address.shipping.all.map(&:recipient).sort
    end

    should "verify that the customer is active in the system" do
      # test the inactive customer first
      bad_address = FactoryBot.build(:address, customer: @sherry, recipient: "Sherry Chen", is_billing: true, active: true)
      deny bad_address.valid?
      # test the nonexistent customer
      ghost = FactoryBot.build(:customer, first_name: "Ghost", user: @u_alexe)
      non_customer_address = FactoryBot.build(:address, customer: ghost)
      deny non_customer_address.valid?
    end 

    should "verify customer's address for this recipient is not already in the system" do
      bad_address = FactoryBot.build(:address, customer: @alexe, recipient: "Jeff Egan", is_billing: false, zip: "15212")
      deny bad_address.valid?
    end 

    should "allow an address 'duplication' if it belongs to a different customer" do
      # same address as before, but belongs now to Melanie instead of Alex
      good_address = FactoryBot.build(:address, customer: @melanie, recipient: "Jeff Egan", is_billing: false, zip: "15212")
      assert good_address.valid?
    end

    should "unset old billing address when new one set" do
      # confirm the current billing address
      assert_equal @ryan_a1, @ryan.billing_address
      # change the billing address to address 2
      @ryan_a1.recipient = "Fred Flood"
      @ryan_a1.save
      # confirm that address is still billing
      assert_equal @ryan_a1, @ryan.billing_address
    end
    
    should "not unset is_billing field when other edits are made" do
      # confirm the current billing address
      assert_equal @alexe_a1, @alexe.billing_address
      refute_equal @alexe_a2, @alexe.billing_address
      # change the billing address to address 2
      @alexe_a2.is_billing = true
      @alexe_a2.save
      # confirm that address 1 no longer billing
      refute_equal @alexe_a1, @alexe.billing_address
      # confirm that address 2 is now billing
      assert_equal @alexe_a2, @alexe.billing_address
    end

    should "not allow an active billing address to be made inactive" do
      assert @alexe_a1.active
      assert @alexe_a1.is_billing
      @alexe_a1.is_billing = false
      deny @alexe_a1.save
    end

    should "not allow a customer's first address to be non-billing" do
      # Sherry was inactive, so she has no addresses right now
      @sherry.make_active
      # build a non-billing address
      @sherry_a1  = FactoryBot.build(:address, customer: @sherry, recipient: "Sherry Chen", is_billing: false)
      deny @sherry_a1.valid?
      # build an inactive billing address
      @sherry_a2  = FactoryBot.build(:address, customer: @sherry, recipient: "Sherry Chen", is_billing: true, active: false)
      deny @sherry_a2.valid?
    end

    should "allow an existing address to be edited" do
      @alexe_a1.street_1 = "5005 Forbes Avenue"
      assert @alexe_a1.valid?
    end

    should "not make inactive because of an improper edit" do
      assert @alexe_a1.active
      @alexe_a1.street_1 = nil
      deny @alexe_a1.valid?
      # try to save the invalid record; see that it is not saved (rollback)
      deny @alexe_a1.save
      # verify that the rollback did not make the address inactive
      assert @alexe_a1.active
    end

    should "show that an address that has never used can be destroyed" do
      new_address = FactoryBot.create(:address, customer: @alexe, recipient: "James Egan", street_1: "2000 Forbes Ave", active: true)
      assert_equal "James Egan", new_address.recipient
      new_address.destroy
      assert new_address.destroyed?
    end

    should "make an improperly destroyed shipping address is made inactive" do
      create_orders
      assert @alexe_a2.active
      deny @alexe_a2.orders.empty?
      @alexe_a2.destroy
      @alexe_a2.reload
      # verify the address is now inactive
      deny @alexe_a2.active
      # ... and that the orders are still there
      deny @alexe_a2.orders.empty?
      # destroy_orders
    end

    should "make sure an improperly destroyed billing address stays active" do
      create_orders
      assert @alexe_a1.active
      assert @alexe_a1.is_billing
      deny @alexe_a1.orders.empty?
      @alexe_a1.destroy
      @alexe_a1.reload
      # verify the address is still active
      assert @alexe_a1.active
      # ... and that the orders are still there
      deny @alexe_a1.orders.empty?
    end

    should "have make_active and make_inactive methods" do
      assert @alexe_a2.active
      @alexe_a2.make_inactive
      @alexe_a2.reload
      deny @alexe_a2.active
      @alexe_a2.make_active
      @alexe_a2.reload
      assert @alexe_a2.active
    end
  end
end