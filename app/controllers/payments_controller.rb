class PaymentsController < InheritedResources::Base
  include Moiper::NotificationControllerHelper

  def success_callback
    project = Project.find(params[:project_id])
    redirect_to project, notice: "Payment done, thank you! Your message will be transformed into a beautiful letter."
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
