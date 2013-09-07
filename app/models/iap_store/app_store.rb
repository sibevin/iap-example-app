require 'json'

module IapStore
  class AppStore < Base

		include HTTParty
		default_params output: 'json'
		default_timeout 5
		format :json

    def self.storecode
      'aps'
    end

    def check_tpv(sku, iap_info)
      receipt = iap_info[:receipt]
      res = do_tpv(receipt)
      tpv_result = check_res(res, sku, iap_info)
      if tpv_result[:status] == 21007
        res = do_tpv(receipt, true)
        tpv_result = check_res(res, sku, iap_info, true)
      end
      return tpv_result
    end

    def show_raw_result(receipt, sandbox = false)
      result = do_tpv(receipt, sandbox)
      JSON.parse(result)
    end

    private

    def do_tpv(receipt, sandbox = false)
      if sandbox
        server_url = 'https://sandbox.itunes.apple.com/verifyReceipt'
      else
        server_url = 'https://buy.itunes.apple.com/verifyReceipt'
      end
      sent_data = {
        'receipt-data' => receipt
      }.to_json
      begin
        res = HTTParty.post(server_url, body: sent_data)
        res.parsed_response
      rescue StandardError => e
        raise AppError::IapError.new(20200,
          'AppStore server has no response, please try it later.', { excep: e })
      end
    end

    def check_res(res, sku, iap_info, sandbox = false)
      begin
        result = JSON.parse(res)
      rescue JSON::ParserError
        raise AppError::IapAppStoreError.new(21991,
          'AppStore: The returned result is not in json format.',
          { iap_info: iap_info })
      end
      unless status = result['status']
        raise AppError::IapAppStoreError.new(21991,
          'AppStore: No status node in the returned result.',
          { iap_info: iap_info })
      end
      if status == 0
        root_hash = result['receipt']
        unless root_hash
          raise AppError::IapAppStoreError.new(21991,
            'AppStore: Unknown format.', { iap_info: iap_info })
        end
        if root_hash['in_app'] &&
           root_hash['in_app'][0] &&
           root_hash['in_app'][0]['product_id']
          # Mac IAP receipt
          receipt_hash = root_hash['in_app'][0]
          store_skucode = receipt_hash['product_id']
        elsif root_hash['item_id']
          # iOS IAP receipt
          receipt_hash = root_hash
          store_skucode = receipt_hash['item_id']
        else
          raise AppError::IapAppStoreError.new(21991,
            'AppStore: Unknown format.', { iap_info: iap_info })
        end
        if receipt_hash['purchase_date'] == nil ||
           receipt_hash['transaction_id'] == nil
          raise AppError::IapAppStoreError.new(21991,
            'AppStore: No purchase_date or transaction_id in returned result.',
            { iap_info: iap_info })
        end
        # check transaction
        transaction = receipt_hash['transaction_id']
        if iap_info[:transaction_val] != transaction
          raise AppError::IapAppStoreError.new(20008, nil, { iap_info: iap_info })
        end
        # check store sku code
        unless sku.store_skucode_match?(self.class.storecode, store_skucode)
          raise AppError::IapAppStoreError.new(20009, nil, { iap_info: iap_info })
        end
        purchased_at = Time.parse(
          receipt_hash['purchase_date'].gsub(/Etc\/GMT/, 'UTC'))
        if receipt_hash['expires_date_formatted']
          expires_at = Time.parse(
            receipt_hash['expires_date_formatted'].gsub(/Etc\/GMT/, 'UTC'))
        else
          expires_at = nil
        end
        return { status: (sandbox ? 21007 : status),
                 purchased_at: purchased_at,
                 expires_at: expires_at }
      elsif status == 21007
        return { status: status }
      else
        raise AppError::IapAppStoreError.new(status, nil, { iap_info: iap_info })
      end
    end
  end
end
