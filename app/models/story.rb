class Story < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :download_count, :kind, :user, :user_id, :project_id
  validates :kind, :user, :project, presence: true
end
