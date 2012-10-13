class InsufficientMessagesToBeSent < Exception; end

class Project < ActiveRecord::Base
  attr_accessible :description, :goal, :image, :name, :image_cache, :remove_image
  has_many :messages
  validates :name, :description, :image, presence: true
  mount_uploader :image, ImageUploader

  def total_messages_sent
    messages.sent.size
  end

  def total_messages_to_be_downloaded
    messages.to_be_sent.size
  end

  def give_messages_to_volunteer(user, quantity)
    quantity = quantity.to_i
    if total_messages_to_be_downloaded < quantity
      raise InsufficientMessagesToBeSent
    end

    messages.to_be_sent.first(quantity.to_i).each do |message|
      message.update_attributes(volunteer: user)
    end
  end
end
