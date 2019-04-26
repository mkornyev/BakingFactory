module Contexts
  module Orders
    # Context for orders (assumes customer, user, address context)
    def create_orders
      @alexe_o1   = FactoryBot.create(:order, customer: @alexe, address: @alexe_a2, grand_total: 5.25, date: 5.days.ago.to_date)
      @alexe_o1.pay
      @alexe_o2   = FactoryBot.create(:order, customer: @alexe, address: @alexe_a2, grand_total: 5.25, date: 3.days.ago.to_date)
      @alexe_o2.pay
      @alexe_o3   = FactoryBot.create(:order, customer: @alexe, address: @alexe_a1, grand_total: 22.50, payment_receipt: nil, date: Date.current)
      @melanie_o1 = FactoryBot.create(:order, customer: @melanie, address: @melanie_a1, grand_total: 5.50, date: 4.days.ago.to_date)
      @melanie_o1.pay
      @melanie_o2 = FactoryBot.create(:order, customer: @melanie, address: @melanie_a1, grand_total: 5.50, payment_receipt: nil, date: Date.current)
      @anthony_o1 = FactoryBot.create(:order, customer: @anthony, address: @anthony_a1, grand_total: 16.50, date: Date.current)
      @anthony_o1.pay
      @ryan_o1    = FactoryBot.create(:order, customer: @ryan, address: @ryan_a1, grand_total: 11, payment_receipt: nil, date: Date.current)
    end
    
    def destroy_orders
      @alexe_o1.delete 
      @alexe_o2.delete
      @alexe_o3.delete
      @melanie_o1.delete
      @melanie_o2.delete
      @anthony_o1.delete
      @ryan_o1.delete
    end

  end
end