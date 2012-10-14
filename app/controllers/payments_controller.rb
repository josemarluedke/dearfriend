class PaymentsController < InheritedResources::Base
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
