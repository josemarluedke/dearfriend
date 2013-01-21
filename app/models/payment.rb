# Encoding: utf-8
class Payment
  attr_accessor :amount, :token, :payer_id, :redirect_uri, :identifier

  DESCRIPTION = {
    item: "Apoie um Herói Postal",
    payment: "Herói Postal"
  }

  def initialize(amount = nil, custom_logger = nil)
    @amount = amount
    @logger = custom_logger || Rails.logger
  end

  def setup!(return_url, cancel_url, pay_client = nil)
    pay_client ||= client
    response = pay_client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true,
      no_shipping: true
    )
    @token = response.token
    @logger.debug("Payment#setup! from #{pay_client.inspect}.")
    @redirect_uri = response.redirect_uri
    self
  end

  def complete!
    response = client.checkout!(token, payer_id, payment_request)
    self.payer_id = payer_id
    self.identifier = response.payment_info.first.transaction_id
  end

  private

  def client
    Paypal::Express::Request.new(PAYPAL_CONFIG)
  end

  def payment_request
    item = {
      name: DESCRIPTION[:item],
      #description: DESCRIPTION[:item],
      amount: amount,
      category: :Digital
    }

    request_attrs = {
      amount: amount,
      description: DESCRIPTION[:payment],
      items: [item],
      currency_code: :BRL
    }

    Paypal::Payment::Request.new(request_attrs)
  end
end
