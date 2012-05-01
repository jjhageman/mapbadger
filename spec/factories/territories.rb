FactoryGirl.define do
  factory :territory do
    sequence(:name){|n| "Territory #{n}" }
  end
end
