module ApplicationHelper
  def get_address_options(user=nil)
    if user.nil? || user.role?(:admin)
      addresses = Address.active.by_recipient.to_a
    else
      addresses = user.customer.addresses.by_recipient.to_a
    end
    addresses.map{|addr| ["#{addr.recipient} : #{addr.street_1}", addr.id] }
  end
end
