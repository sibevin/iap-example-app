module AppError
  class Base < StandardError
    attr_reader :code, :status, :msg, :info

    def initialize(code, msg = nil, info = {})
      @code = code
      @info = info
      if error_codes.keys.include?(code)
        @status = error_codes[code][:status]
        @msg = msg || error_codes[code][:msg]
      else
        @code = INTERNAL_ERROR_CODE
        @status = :internal_error
        @msg = INTERNAL_ERROR_MSG
      end
      @msg = default_masked_msg if msg == :masked
      @msg = "#{@msg}(#{@code})"
    end

    def message
      "Code:\"#{@code}\" Status:\"#{@status.to_s}\" Msg:\"#{@msg}\" #{@info.blank? ? "" : "Info:\"#{@info.inspect}\""}"
    end

    private

    def default_masked_msg
      'Error occurs.'
    end

    def error_codes
      raise 'You should implement this method in your AppError-based class.'
    end
  end
end
