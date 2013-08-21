module AppError
  class UserError < Base
    private

    def error_codes
      {
        10001 => {
          :status => :failed,
          :msg => 'Cannot find the user account.'
        },
        10002 => {
          :status => :failed,
          :msg => 'Password is incorrect.'
        },
        10003 => {
          :status => :failed,
          :msg => 'This account is not activated.'
        }
      }
    end

    def default_masked_msg
      'Your account or password is incorrect.'
    end
  end
end
