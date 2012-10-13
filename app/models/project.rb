class Project < ActiveRecord::Base
  attr_accessible :description, :goal, :image, :name
  has_many :messages
  validates :name, :description, presence: true
  mount_uploader :image, ImageUploader
end
