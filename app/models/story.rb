class Story < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :download_count, :kind, :user, :user_id, :project, :project_id
  validates :kind, :user, :project, presence: true

  scope :by_downloads, where(kind: "downloaded_messages")
  scope :by_messages, where(kind: "created_message")
end
