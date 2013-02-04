class PaymentsController < InheritedResources::Base
  def success_callback
    if project = Project.find(params[:project_id])
      redirect_to project, notice: "Payment done, thank you! Your message will be transformed into a beautiful letter."
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  def notification
    moip_notification do |notification|
      if notification.payment_status.eql?(:finished)
        message = Message.find_by_payment_token(notification.id)
        if message
          message.confirm!(notification.moip_id)
        else
          return head 422
        end
      end

      head 200
    end
  end
end
