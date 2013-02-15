# encoding: utf-8
class Payment
  attr_accessor :amount, :token, :redirect_uri

  DESCRIPTION = 'Apoie um Herói Postal'

  def initialize(amount = nil, custom_logger = nil)
    @amount = amount
    @logger = custom_logger || Rails.logger
  end

  def id
    rand
  end

  def checkout!(return_url, notification_url)
    payment = Moiper::Payment.new(
      id: id,
      description: DESCRIPTION,
      price: @amount,
      return_url: return_url,
      notification_url: notification_url
    )

    response = payment.checkout
    @redirect_uri = response.checkout_url
    @token        = response.token
    response
  end
end
