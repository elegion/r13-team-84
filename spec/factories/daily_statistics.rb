FactoryGirl.define do
  factory :daily_statistics do
    user
    locale      'ru'
    stats_date  Date.today
  end
end
