FactoryGirl.define do
  factory :room do
    sequence(:name) {|n| "Room #{n}" }
    locale 'en'
    users_count  1
  end
end
