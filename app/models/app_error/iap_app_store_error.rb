module AppError
  class IapAppStoreError < IapError
    private

    def error_codes
      super.merge(
        21000 => {
          :status => :failed,
          :msg => 'The App Store could not read the JSON object you provided.'
        },
        21002 => {
          :status => :failed,
          :msg => 'The data in the receipt-data property was malformed.'
        },
        21003 => {
          :status => :retry,
          :msg => 'The receipt could not be auticated.'
        },
        21004 => {
          :status => :failed,
          :msg => 'The shared secret you provided does not match the shared secret on file for your account.'
        },
        21005 => {
          :status => :retry,
          :msg => 'The receipt server is not currently available.'
        },
        21006 => {
          :status => :failed,
          :msg => 'This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response.'
        },
        21007 => {
          :status => :sandbox,
          :msg => 'This receipt is a sandbox receipt, but it was sent to the production service for verification.'
        },
        21008 => {
          :status => :failed,
          :msg => 'This receipt is a production receipt, but it was sent to the sandbox service for verification.'
        },
        21901 => {
          :status => :failed,
          :msg => 'AppStore server: The store server return a invalid JB response.'
        },
        21991 => {
          :status => :failed,
          :msg => 'AppStore server: The store server return an unknown format response.'
        },
        21999 => {
          :status => :failed,
          :msg => 'AppStore server: Unknown error occurs.'
        }
      )
    end

    def default_masked_msg
      'Error occurs in App Store verification.'
    end
  end
end
