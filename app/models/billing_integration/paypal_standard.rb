class BillingIntegration::PaypalStandard < BillingIntegration
  preference :merchant, :string, :default=>"" #Set to your merchant account
  preference :password, :string, :default=>''
  preference :currency_code, :string, :default=>'GBP'
  


end
