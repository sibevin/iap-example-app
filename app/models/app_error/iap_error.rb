module AppError
  class IapError < Base
    def initialize(code, msg = nil, info = {})
      super(code, msg, info)
      if (@status == :success || @status == :failed) && !@info[:iap_info].is_a?(Hash)
        raise 'You should provide iap_info if status is :success or :failed'
      end
      if @info[:iap_info]
        @info[:iap_info].merge!(error_code: @code)
      end
    end

    private

    def error_codes
      {
        20001 => {
          :status => :invalid_request,
          :msg => 'Purchase information format is incorrect.'
        },
        20002 => {
          :status => :invalid_request,
          :msg => 'Device information format is incorrect.'
        },
        20003 => {
          :status => :invalid_request,
          :msg => 'Unknown store.'
        },
        20004 => {
          :status => :failed,
          :msg => 'JB format receipt(urus).'
        },
        20005 => {
          :status => :invalid_request,
          :msg => 'Unknown sku.'
        },
        20006 => {
          :status => :failed,
          :msg => 'An existing transaction with the wrong user.'
        },
        20007 => {
          :status => :failed,
          :msg => 'An existing transaction with the wrong sku.'
        },
        20008 => {
          :status => :failed,
          :msg => 'The transaction is not matched.'
        },
        20009 => {
          :status => :failed,
          :msg => 'The store skucode is not matched.'
        },
        20100 => {
          :status => :duplicated,
          :msg => 'A duplicated IAP request is sent.'
        },
        20200 => {
          :status => :retry,
          :msg => 'Client should send the IAP request again.'
        }
      }
    end

    def default_masked_msg
      'Error occurs.'
    end
  end
end
