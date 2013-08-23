module AppError
  class IapError < Base
    private

    def error_codes
      {
        20001 => {
          :status => :failed,
          :msg => 'Device format is incorrect.'
        },
        20002 => {
          :status => :failed,
          :msg => 'Unknown store.'
        },
        20003 => {
          :status => :failed,
          :msg => 'JB format receipt(urus).'
        },
        20004 => {
          :status => :failed,
          :msg => 'Unknown sku.'
        },
        20005 => {
          :status => :failed,
          :msg => 'An existing transaction with the wrong user.'
        },
        20006 => {
          :status => :failed,
          :msg => 'An existing transaction with the wrong sku.'
        },
        20000 => {
          :status => :success,
          :msg => 'A valid IAP request.'
        },
        20010 => {
          :status => :duplicated,
          :msg => 'A duplicated IAP request is sent.'
        },
        20020 => {
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
