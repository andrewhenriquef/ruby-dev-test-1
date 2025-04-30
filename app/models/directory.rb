class Directory < ApplicationRecord
  belongs_to :parent_directory,
             class_name: "Directory",
             foreign_key: :parent_id,
             optional: true

  has_many :subdirectories,
           class_name: "Directory",
           foreign_key: :parent_id,
           dependent: :destroy,
           inverse_of: :parent_directory

  has_many :documents,
           dependent: :destroy,
           inverse_of: :directory

  validates :name, presence: true

  def path
    return name if parent_directory.nil?

    [ parent_directory.path, name ].compact.join("/")
  end

  def is_root?
    parent_directory.nil?
  end

  def is_subdirectory?
    !is_root?
  end
end
