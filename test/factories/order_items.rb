FactoryBot.define do
  factory :order_item do
    shipped_on nil
    association :order
    association :item
    quantity 1
  end
end
