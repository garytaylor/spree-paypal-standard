Rails.application.routes.draw do |map|
  map.resources :orders, :member=>{:thank_you=>:get} do |order|
    order.resource :checkout, :controller=>"checkout", :member => {:paypal_standard_checkout => :any, :paypal_standard_payment => :any, :paypal_standard_confirm => :any, :paypal_standard_finish => :any}
  end

  map.paypal_standard_notify "/paypal_standard_notify", :controller => 'spree/paypal_standard_callbacks', :action => :notify
  match "/paypal_standard_return"=>'spree/paypal_standard_callbacks#return', :as=>:paypal_standard_return, :via=>:post

  map.namespace :admin do |admin|
    admin.resources :orders do |order|
      order.resources :paypal_standard_payments, :member => {:capture => :get, :refund => :any}, :has_many => [:txns]
    end
  end
end
