class Project < ActiveRecord::Base
  attr_accessible :description, :goal, :image_url, :name
  has_many :messages
  validates :name, :description, presence: true
end
