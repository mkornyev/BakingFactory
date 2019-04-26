FactoryBot.define do
  factory :customer do
    first_name "Ed"
    last_name "Gruberman"
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    email { |u| "#{u.first_name[0]}#{u.last_name}#{(1..99).to_a.sample}@example.com".downcase }
    association :user
    active true
  end
end
