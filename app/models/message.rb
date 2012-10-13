class Message < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :volunteer, class_name: "User"
  attr_accessible :confirmed_payment, :from_address, :letter, :payment_token, :to_address, :transaction_id, :author, :project_id, :volunteer, :price
  validates :letter, :author, :from_address, :to_address, presence: true

  PRICE = 5

  def letter_with_project?
    valid? && project.present?
  end

  # TODO: Entire #paid? implementation
  def paid?
    false
  end
end
