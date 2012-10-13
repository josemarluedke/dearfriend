class Project < ActiveRecord::Base
  attr_accessible :description, :goal, :image_url, :name
  has_many :messages
  validates :name, :description, presence: true

  def total_messages_sent
    messages.where("volunteer_id IS NOT ?", nil).size
  end
end
