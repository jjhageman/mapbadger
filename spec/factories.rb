FactoryGirl.define do
  factory :territory do
    sequence(:name){|n| "Territory #{n}" }
  end

  factory :region do
    sequence(:name){|n| "Region #{n}" }
  end

  factory :zcta do
  end
end
