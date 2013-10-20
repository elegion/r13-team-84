FactoryGirl.define do
  factory :user do
    name    "Test User"
    rating  Settings.rating.initial
  end
end
