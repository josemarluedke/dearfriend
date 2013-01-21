class Message < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :volunteer, class_name: "User"

  attr_accessible :confirmed_payment, :from_address, :letter, :payment_token,
                  :to_address, :transaction_id, :author, :project_id,
                  :volunteer, :price, :project, :downloaded_at

  validates :letter, :author, :from_address, :to_address, presence: true

  PRICE = 10

  scope :sent, where("volunteer_id IS NOT ?", nil)
  scope :paid_messages, where(confirmed_payment: true)
  scope :to_be_sent, paid_messages.where(volunteer_id: nil)

  before_create :create_payment_token

  def letter_with_project?
    valid? && project.present?
  end

  def paid?
    confirmed_payment
  end

  def as_text(index = nil)
    string = <<TEXT
FROM_ADDRESS
#{author.name}
#{from_address}

TO_ADDRESS
#{to_address}

LETTER
#{letter}
TEXT
    string.insert(0, "MESSAGE ##{index+1}\n\n") unless index.nil?
    string
  end

  def confirm!(transaction_id)
    update_attributes(confirmed_payment: true,
                      transaction_id: transaction_id)
    Story.create! kind: "created_message", project: project, user: author
  end

  protected

  def create_payment_token
    self.payment_token = SecureRandom.hex(20)
  end
end
