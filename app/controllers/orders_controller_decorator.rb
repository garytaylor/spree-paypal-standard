OrdersController.class_eval do
  def thank_you
    @order = Order.find_by_number(params[:id])
    @current_order=nil
  end
end