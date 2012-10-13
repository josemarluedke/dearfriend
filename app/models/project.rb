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

    assigned_messages = messages.to_be_sent.first(quantity.to_i)
    assigned_messages.each do |message|
      message.update_attributes(volunteer: user)
    end

    messages_file = ""
    messages_file << as_text
    messages_separator = "\n=====\n\n"
    messages_file << messages_separator
    messages_file << assigned_messages.each_with_index.
      map { |m, index| m.as_text(index) }.join(messages_separator)

    messages_file
  end

  def as_text
    <<TEXT
Project "#{name}"
#{description}
TEXT
  end
end
