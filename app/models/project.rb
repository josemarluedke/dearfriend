class Project < ActiveRecord::Base
  attr_accessible :description, :goal, :image_url, :name
end
