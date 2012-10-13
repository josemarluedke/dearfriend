class Message < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :volunteer, class_name: "User"
  attr_accessible :confirmed_payment, :from_address, :letter, :payment_token, :to_address, :transaction_id, :author, :project, :volunteer
  validates :letter, :author, :from_address, :to_address, presence: true

  def complete_letter?
    letter.present? && from_address.present? && to_address.present?
  end

  def letter_with_project?
    complete_letter? && project.present?
  end
end
