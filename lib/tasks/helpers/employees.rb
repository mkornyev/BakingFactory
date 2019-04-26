module Populator
  module Employees
    def create_employees
      mark_user = User.new
      mark_user.username = "mark"
      mark_user.password = "secret"
      mark_user.password_confirmation = "secret"
      mark_user.role = "admin"
      mark_user.save!
      mark = Customer.new
      mark.first_name = "Mark"
      mark.last_name = "Heimann"
      mark.email = "mark@razingrooks.org"
      mark.phone = "412-268-2323"
      mark.user_id = mark_user.id
      mark.active = true
      mark.save!
  
      alex_user = User.new
      alex_user.username = "alex"
      alex_user.password = "secret"
      alex_user.password_confirmation = "secret"
      alex_user.role = "admin"
      alex_user.save!
      alex = Customer.new
      alex.first_name = "Alex"
      alex.last_name = "Heimann"
      alex.email = "alex@razingrooks.org"
      alex.phone = "(412) 268-3259"
      alex.user_id = alex_user.id
      alex.active = true
      alex.save!
  
      baker_user = User.new
      baker_user.username = "baker"
      baker_user.password = "secret"
      baker_user.password_confirmation = "secret"
      baker_user.role = "baker"
      baker_user.save!
      
      shipper_user = User.new
      shipper_user.username = "shipper"
      shipper_user.password = "secret"
      shipper_user.password_confirmation = "secret"
      shipper_user.role = "shipper"
      shipper_user.save!
    end
  end
end