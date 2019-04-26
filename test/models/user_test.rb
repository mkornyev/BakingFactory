require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_one(:customer)
  should have_secure_password

  # test validations
  should validate_presence_of(:username)

  should allow_value("admin").for(:role)
  should allow_value("baker").for(:role)
  should allow_value("shipper").for(:role)
  should allow_value("customer").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("leader").for(:role)
  should_not allow_value(nil).for(:role)
  
  
  # context
  context "Within context" do
    setup do
      create_employee_users
    end
    
    teardown do
      destroy_employee_users
    end

    should "require users to have unique, case-insensitive usernames" do
      assert_equal "mark", @mark.username
      # try to switch to Alex's username 'tank'
      @mark.username = "TANK"
      deny @mark.valid?, "#{@mark.username}"
    end

    should "require a password for new users" do
      bad_user = FactoryBot.build(:user, username: "wheezy", password: nil)
      deny bad_user.valid?
    end
    
    should "require passwords to be confirmed and matching" do
      bad_user_1 = FactoryBot.build(:user, username: "wheezy", password: "secret", password_confirmation: nil)
      deny bad_user_1.valid?
      bad_user_2 = FactoryBot.build(:user, username: "wheezy", password: "secret", password_confirmation: "sauce")
      deny bad_user_2.valid?
    end
    
    should "require passwords to be at least four characters" do
      bad_user = FactoryBot.build(:user, username: "wheezy", password: "no", password_confirmation: "no")
      deny bad_user.valid?
    end

    should "have a role? method to use in authorization" do
      assert @mark.role?(:admin)
      deny @mark.role?(:baker)
      assert @baker.role?(:baker)
      deny @baker.role?(:admin)
    end

    should "have a working scope called active" do
      assert_equal ["baker","mark","shipper","tank"], User.active.all.map(&:username).sort
    end

    should "have a working scope called inactive" do
      assert_equal ["old_shipper"], User.inactive.all.map(&:username).sort
    end

    should "have a working scope called employees" do
      create_customer_users
      assert @u_alexe.active
      assert_equal ["baker","mark","old_shipper","shipper","tank"], User.employees.all.map(&:username).sort
      destroy_customer_users
    end

    should "have a working scope called alphabetical" do
      assert_equal ["baker","mark","old_shipper","shipper","tank"], User.alphabetical.all.map(&:username)
    end

    should "have a working scope called by_role" do
      assert_equal ["admin","admin","baker","shipper","shipper"], User.by_role.all.map(&:role)
    end

    should "have make_active and make_inactive methods" do
      assert @mark.active
      @mark.make_inactive
      @mark.reload
      deny @mark.active
      @mark.make_active
      @mark.reload
      assert @mark.active
    end

  end
end
