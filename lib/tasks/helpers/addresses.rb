module Populator
  module Addresses
    def create_addresses_for(customers)

      customers.each do |customer|
        billing = FactoryBot.create(:address, customer: customer, 
          recipient: "#{customer.proper_name}",
          street_1: "#{Faker::Address.street_address}",
          city: "#{Faker::Address.city}",
          state: "#{Address::STATES_LIST.to_h.values.sample}",
          zip: "#{rand(100000).to_s.rjust(5,"0")}",
          is_billing: true)
  
        if rand(3).zero?
          address_2 = FactoryBot.create(:address, customer: customer,
            recipient: "James T. Kirk", 
            street_1: "#{Faker::Address.street_address}",
            city: "#{Faker::Address.city}",
            state: "#{Address::STATES_LIST.to_h.values.sample}",
            zip: "#{rand(100000).to_s.rjust(5,"0")}")          
        end
  
        if rand(4).zero?
          address_3 = FactoryBot.create(:address, customer: customer, 
            recipient: "Jean Luc Picard",
            street_1: "#{Faker::Address.street_address}",
            street_2: "#{Faker::Address.secondary_address}",
            city: "#{Faker::Address.city}",
            state: "#{Address::STATES_LIST.to_h.values.sample}",
            zip: "#{rand(100000).to_s.rjust(5,"0")}")          
        end
      end
    end
  end
end