require 'spree_core'

module SpreePaypalStandard
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      if File.basename( $0 ) != "rake"
        [
          BillingIntegration::PaypalStandard
        ].each{|gw|
          begin
            gw.register
          rescue Exception => e
            $stderr.puts "Error registering gateway #{gw}: #{e}"
          end
        }
      end
      CheckoutController.class_eval do
        include ::Spree::PaypalStandard
      end
      ActionView::Base.class_eval do
        include ::ActiveMerchant::Billing::Integrations::ActionViewHelper
      end

    end

    config.to_prepare &method(:activate).to_proc
  end
end
