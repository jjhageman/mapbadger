FactoryGirl.define do
  factory :company do
    sequence(:email){|n| "example#{n}@acme.com" }
    password 'please'
    password_confirmation 'please'
    confirmed_at Time.now
  end
end
