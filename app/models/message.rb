class Message < ActiveRecord::Base
  belongs_to :author
  belongs_to :project
  belongs_to :volunteer
  attr_accessible :confirmed_payment, :from_address, :letter, :payment_token, :to_address, :transaction_id
end
