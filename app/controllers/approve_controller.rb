class ApproveController < ApplicationController
  #
  # Save order record.
  # params record_id string
  # params record_type string
  # route /:approve/:register/:record_type/:record_id
  #
  def register
    @data = {
      record_id: params[:record_id],
      record_type: params[:record_type],
      tranid: params[:tranid],
      approved: nil
    }
    @saved = OrderLog.create @data
    if @saved
      @data[:id] = @saved.id
      @hash = make_encrypt(@data)
    else
      @hash = nil
    end

    @limitDate = check_limit(@saved) + (60 * 60 * 9)

    @result = {
      'url' => 'https://www.uluru.tokyo/approve/select/' + @hash,
      'limit' => @limitDate.strftime('%Y-%m-%d %H:%M:%S')
    }

    render :json => @result
  end

  #
  # Select accept or reject page
  # params hash string
  # route /:approve/:select/:hash
  #
  def select
    @encrypt_message = params[:hash]
    # 復号化
    @data = make_decrypt(@encrypt_message)

    @orderLog = OrderLog.new
    @recordList = OrderLog::RECORD_LIST

    begin
      @orderLog = OrderLog.find(@data[:id])
      @limitDate = check_limit(@orderLog)
      if @limitDate === false
        raise '承認期限切れです'
      end
      unless @orderLog.approved.nil?
        raise '既に更新されています。'
      end
    rescue => e
      flash[:error] = e.message
      redirect_to controller: 'approve', action: 'error'
    end
  end

  #
  # Update record of approve field.
  #
  def update
    begin
      OrderLog.transaction do
        @orderLog = OrderLog.find(params[:order_log][:id])

        @limitDate = check_limit(@orderLog)
        if @limitDate === false
          raise '承認期限切れです'
        end

        if @orderLog.approved.nil?
          @orderLog.approved = params[:accept].present? ? OrderLog::APPROVED_ACCEPT : OrderLog::APPROVED_REJECT

          if OrderLog.update(@orderLog.id, :approved => @orderLog.approved)
            updateNetSuiteField(@orderLog)
          else
            raise '保存に失敗しました。再度お試しください。'
          end
        else
          raise '既に更新されています。'
        end
      end
      redirect_to controller: 'approve', action: 'thanks'
    rescue => e
      flash[:error] = e.message
      redirect_to controller: 'approve', action: 'error'
    end
  end

  #
  # Thanks page from update.
  #
  def thanks
  end

  private
  #
  # 暗号化
  #
  def make_encrypt(data)
    encryptor = common_encryptor
    return encryptor.encrypt_and_sign(data)
  end
  #
  # 複合化
  #
  def make_decrypt(data)
    decryptor = common_encryptor
    return decryptor.decrypt_and_verify(data)
  end

  def common_encryptor()
    return ::ActiveSupport::MessageEncryptor.new(
      Rails.application.secrets.secret_key_base,
      cipher: 'aes-256-cbc'
    )
  end
  #
  # approvedレコードの更新期間が指定日以内かチェック
  #
  def check_limit(orderLog)
    @limitDate = orderLog.created_at + (60 * 60 * 24 * OrderLog::APPROVE_LIMIT)
    return @limitDate >= DateTime.now ? @limitDate : false
  end

  def updateNetSuiteField(orderLog)
    @account = "3701294"
    @email = "netsuite_api@uluru.jp"
    @password = "Urulu12345"
    @role = "3"
    uri = URI.parse("https://rest.netsuite.com/app/site/hosting/restlet.nl?script=14&deploy=1")

    response = nil

    request = Net::HTTP::Post.new(uri.request_uri, initheader = {
      'Authorization' => "NLAuth nlauth_account=#{@account}, nlauth_email=#{@email}, nlauth_signature=#{@password}, nlauth_role=#{@role}",
      'Content-Type' =>'application/json'
    })

    request.body = {
      'record_id' => orderLog.record_id,
      'record_type' => orderLog.record_type,
      'approved' => OrderLog::APPROVED_TEXT[orderLog.approved]
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.start do |h|
      response = h.request(request)
      unless response.code == '200'
        raise 'NetSuiteへの接続に失敗しました。'
      end
    end
  end
end
