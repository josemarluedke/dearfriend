class InsufficientMessagesToBeSent < Exception; end

class Project < ActiveRecord::Base
  attr_accessible :description, :goal, :image, :name, :image_cache, :remove_image
  has_many :messages
  validates :name, :description, :image, :goal, presence: true
  mount_uploader :image, ImageUploader

  scope :all_can_receive_messages, ->{ all.select { |item| item.can_receive_message? } }

  def total_messages_sent
    messages.sent.size
  end

  def total_messages_to_be_downloaded
    messages.to_be_sent.size
  end

  def can_receive_message?
    messages.paid_messages.size < goal
  end

  def give_messages_to_volunteer(user, quantity)
    quantity = quantity.to_i
    if total_messages_to_be_downloaded < quantity
      raise InsufficientMessagesToBeSent
    end

    messages_as_text(assign_volunter_to_messages(quantity, user))
  end

  def messages_as_text(messages_collection)
    messages_file = ""
    messages_file << as_text
    messages_separator = "\n=====\n\n"
    messages_file << messages_separator
    messages_file << messages_collection.each_with_index.
      map { |m, index| m.as_text(index) }.join(messages_separator)
  end

  def messages_as_text_from(day)
    messages_as_text(messages.where(downloaded_at: day))
  end

  def as_text
    <<TEXT
Dear Friend "#{name}"
#{description}
TEXT
  end

  private

  def assign_volunter_to_messages(quantity, user)
    assigned_messages = messages.to_be_sent.first(quantity)
    assigned_messages.each do |message|
      message.update_attributes(volunteer: user, downloaded_at: Date.today)
    end
  end
end
