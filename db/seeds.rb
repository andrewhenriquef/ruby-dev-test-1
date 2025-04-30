# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

musics_directory = Directory.create(name: "Musics")
rock_directory = musics_directory.subdirectories.create(name: "Rock")
evanescence_directory = rock_directory.subdirectories.create(name: "Evanescence")
toxicity_directory = rock_directory.subdirectories.create(name: "Toxicity")

dummy_file_path = Rails.root.join("spec", "fixtures", "files", "test.txt")

musics_directory.documents.create(name: "xinbinha", content_type: :txt, file: File.open(dummy_file_path))
rock_directory.documents.create(name: "Have you ever seen the rain", content_type: :txt, file: File.open(dummy_file_path))
evanescence_directory.documents.create(name: "Fallen", content_type: :txt, file: File.open(dummy_file_path))
toxicity_directory.documents.create(name: "Toxicity", content_type: :txt, file: File.open(dummy_file_path))
