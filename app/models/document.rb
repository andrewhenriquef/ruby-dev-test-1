class Document < ApplicationRecord
  belongs_to :directory

  has_one_attached :file

  validates :file, presence: true

  def path
    "#{directory.path}/#{original_filename}"
  end

  def original_filename
    file.filename.to_s
  end
end
