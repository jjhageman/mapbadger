FactoryGirl.define do
  factory :territory do
    sequence(:name){|n| "Territory #{n}" }
  end

  factory :region do
    sequence(:name){|n| "Region #{n}" }
  end

  factory :zipcode do
  end
end
