FactoryBot.define do
  factory :address do
    recipient "Ted Gruberman"
    street_1 "5000 Forbes Avenue"
    street_2 nil
    city "Pittsburgh"
    state "PA"
    zip "15213"
    association :customer
    is_billing false
    active true
  end
end
