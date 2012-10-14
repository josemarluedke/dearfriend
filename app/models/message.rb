class Message < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :project
  belongs_to :volunteer, class_name: "User"

  attr_accessible :confirmed_payment, :from_address, :letter, :payment_token,
                  :to_address, :transaction_id, :author, :project_id,
                  :volunteer, :price, :project, :downloaded_at

  validates :letter, :author, :from_address, :to_address, presence: true

  PRICE = 5

  scope :sent, where("volunteer_id IS NOT ?", nil)
  scope :to_be_sent, where(volunteer_id: nil)
  scope :paid_messages, where(confirmed_payment: true)

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

 def confirm!
    update_column(:confirmed_payment, true)
    save
  end

  protected

  def create_payment_token
    self.payment_token = SecureRandom.hex(20)
  end
end
