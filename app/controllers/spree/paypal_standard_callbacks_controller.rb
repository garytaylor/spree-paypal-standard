module Spree
  class PaypalStandardCallbacksController < ::ActionController::Base
    protect_from_forgery :except=>[:notify,:return]
    #Called by paypoint when the payment is paid, but all security measures must be taken as this could easily be spoofed
    def notify
      payment_method=PaymentMethod.find_by_id(params[:payment_method_id])
      notify = ActiveMerchant::Billing::Integrations::Paypal::Notification.new(request.raw_post)
      @order = ::Order.find_by_number(notify.item_id)
      if notify.acknowledge
       begin
         if notify.complete? and @order.total.to_f == notify.amount.to_f
           p=@order.payment
           p.complete
           @order.state='complete'
           @order.finalize!
         else
           Rails.logger.warn "Warning:: Order #{notify.item_id} was not authorised - reason #{notify.message rescue ''}"
           p=@order.payment
           p.fail
           p.save
         end

       rescue => e
         p=@order.payment
         p.fail
         p.save
         raise

       end
      end

      render :text=>'', :status=>200

    end

    #Paypal sends us a post with lots of useful information in it, however at this point we ignore it and just wait for the IPN
    def return
      notify = ActiveMerchant::Billing::Integrations::Paypal::Notification.new(request.raw_post)
      @order = ::Order.find_by_number(notify.item_id)
      if notify.acknowledge
       begin
         redirect_to thank_you_order_url(@order)
       rescue => e
         redirect_to '/'
       end
      end
    end

  end
end