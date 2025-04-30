FactoryBot.define do
  factory :document do
    name { Faker::Lorem.word }
    association :directory, factory: :directory
    file do
      Rack::Test::UploadedFile.new(
        Rails.root.join(
          "spec",
          "fixtures",
          "files",
          "test.txt"
        ),
        "text/plain"
      )
    end
  end
end
