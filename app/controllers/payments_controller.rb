class PaymentsController < InheritedResources::Base
  before_filter :authenticate_user!
  actions :create

  def create
    message = Message.find(params[:message_id])
    payment = Payment.new(Message::PRICE)
    payment.setup!(
      success_callback_payment_url(project_id: message.project),
      cancel_callback_payment_url(project_id: message.project)
    )
    message.payment_token = payment.token
    message.save

    redirect_to payment.redirect_uri
  end

  def success_callback
    if message = Message.find_by_payment_token(params[:token])
      payment = Payment.new
      payment.token = params[:token]
      payment.payer_id = params[:PayerID]
      payment.amount = Message::PRICE
      payment.complete!

      message.confirm!(payment.identifier)
      redirect_to message.project, notice: "Payment done, thank you! Your message will be transformed into a beautiful letter."
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  def cancel_callback
    redirect_to root_url, alert: "Payment canceled. Come back later to transform your message into a letter."
  end
end
