module Contexts
  module Users
    # Context for users
    def create_customer_users
      @u_alexe   = FactoryBot.create(:user, username: "alexe")
      @u_melanie = FactoryBot.create(:user, username: "melanie")
      @u_anthony = FactoryBot.create(:user, username: "anthony")
      @u_ryan    = FactoryBot.create(:user, username: "ryan")
      @u_sherry  = FactoryBot.create(:user, username: "sherry", active: false)
    end
    
    def destroy_customer_users
      @u_alexe.delete
      @u_melanie.delete
      @u_anthony.delete
      @u_ryan.delete 
      @u_sherry.delete
    end

    def create_employee_users
      @alex        = FactoryBot.create(:user, username: "tank", role: "admin")
      @mark        = FactoryBot.create(:user, username: "mark", role: "admin")
      @baker       = FactoryBot.create(:user, username: "baker", role: "baker")
      @shipper     = FactoryBot.create(:user, username: "shipper", role: "shipper")
      @old_shipper = FactoryBot.create(:user, username: "old_shipper", role: "shipper", active: false)
    end

    def destroy_employee_users
      @alex.delete
      @mark.delete
      @baker.delete
      @shipper.delete
      @old_shipper.delete
    end

  end
end