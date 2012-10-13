class Project < ActiveRecord::Base
  attr_accessible :description, :goal, :image, :name, :image_cache, :remove_image
  has_many :messages
  validates :name, :description, presence: true
  mount_uploader :image, ImageUploader


  def total_messages_sent
    messages.where("volunteer_id IS NOT ?", nil).size
  end
end
