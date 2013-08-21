require 'spec_helper'

describe AppError::UserError do
  it "should create an exception with correct info." do
    error_codes = {
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
    error_codes.keys.each do |code|
      e = AppError::UserError.new(code)
      e.code.should == code
      e.status.should == error_codes[code][:status]
      e.msg.should == "#{error_codes[code][:msg]}(#{code})"
    end
  end

  it "should create an exception with the masked message." do
    code = 10001
    default_masked_msg = 'Your account or password is incorrect.'
    e = AppError::UserError.new(code, :masked)
    e.msg.should == "#{default_masked_msg}(#{code})"
  end

  it "should create an exception with the given message." do
    msg = 'A given message.'
    code = 10001
    e = AppError::UserError.new(code, msg)
    e.msg.should == "#{msg}(#{code})"
  end

  it "should create an exception with the internal error if the given code is unknown." do
    code = 'unknown code'
    e = AppError::UserError.new(code)
    e.status.should == :internal_error
    e.code.should == AppError::INTERNAL_ERROR_CODE
    e.msg.should == "#{AppError::INTERNAL_ERROR_MSG}(#{AppError::INTERNAL_ERROR_CODE})"
  end

  it "should create an exception with the given info." do
    info = 'A given info.'
    code = 10001
    e = AppError::UserError.new(code, nil, info)
    e.info.should == info
  end
end
