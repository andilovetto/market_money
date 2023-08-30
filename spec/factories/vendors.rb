FactoryBot.define do
  factory :vendor do
    name { Faker::TvShows::RuPaul.queen }
    description { Faker::TvShows::NewGirl.quote }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end