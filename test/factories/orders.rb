FactoryBot.define do
  factory :order do
    date Date.current
    association :customer
    association :address
    grand_total 0.00
    credit_card_number "4123456789012345"
    expiration_year 1.year.from_now.year
    expiration_month 12
    payment_receipt nil
  end
end
