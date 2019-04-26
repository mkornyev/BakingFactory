FactoryBot.define do
  factory :user do
    sequence :username do |n|
      "user#{n}"
    end
    password "secret"
    password_confirmation "secret"
    role "customer"
    active true
  end
end
