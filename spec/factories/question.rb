FactoryGirl.define do
  factory :question do
    sequence(:text) {|n| "Question #{n}" }
    locale 'en'
  end
end
