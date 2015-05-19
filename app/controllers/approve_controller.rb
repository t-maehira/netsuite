class ApproveController < ApplicationController
  def index
    @orderLog = OrderLog.new
    @orderLog.type = 'check'
    @orderLog.order_id = '1122'

    @sheetList = OrderLog::SHEET_LIST
#    @orderLog.type = params[:type]
#    @orderLog.order_id = params[:order_id]
  end

  def update
#    @type = params[:type]
#    @orderId = params[:order_id]
#
#    order_log = OrderLog.new(type: params[:type], order_id: params[:order_id])
#    @result = order_log.save
#
#    # return params type = :type
#    # return params order_id = :order_id
    render :json => 'hoge' and return
#    #render :json => params[:orderLog] and return

  end
end
