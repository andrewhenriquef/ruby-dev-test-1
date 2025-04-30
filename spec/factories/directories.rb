FactoryBot.define do
  factory :directory do
    name { Faker::Lorem.word }
    parent_directory { nil }
  end
end
