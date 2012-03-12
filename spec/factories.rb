FactoryGirl.define do
  factory :company do
    sequence(:email){|n| "example#{n}@acme.com" }
    password 'please'
    password_confirmation 'please'
    confirmed_at Time.now
  end

  factory :territory do
    sequence(:name){|n| "Territory #{n}" }
  end

  factory :region do
    sequence(:name){|n| "Region #{n}" }
  end

  factory :zipcode do
  end
end
