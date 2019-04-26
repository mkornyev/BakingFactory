module Contexts
  module Addresses
    # Context for addresses (assumes customer and user context)
    def create_addresses
      @alexe_a1   = FactoryBot.create(:address, customer: @alexe, recipient: "Alex Egan", is_billing: true)
      @melanie_a1 = FactoryBot.create(:address, customer: @melanie, recipient: "Melanie Freeman", is_billing: true)
      @anthony_a1 = FactoryBot.create(:address, customer: @anthony, recipient: "Anthony Corletti", is_billing: true)
      @ryan_a1    = FactoryBot.create(:address, customer: @ryan, recipient: "Ryan Flood", is_billing: true)
      # @sherry_a1  = FactoryBot.create(:address, customer: @sherry, recipient: "Sherry Chen", is_billing: true, active: false)
      @alexe_a2   = FactoryBot.create(:address, customer: @alexe, recipient: "Jeff Egan", street_1: "4000 Forbes Ave", zip: "15212")
      @alexe_a3   = FactoryBot.create(:address, customer: @alexe, recipient: "Zach Egan", street_1: "3000 Forbes Ave", active: false)
    end
    
    def destroy_addresses
      @alexe_a1.delete
      @melanie_a1.delete
      @anthony_a1.delete
      @ryan_a1.delete 
      # @sherry_a1.delete
      @alexe_a2.delete
      @alexe_a3.delete
    end

  end
end