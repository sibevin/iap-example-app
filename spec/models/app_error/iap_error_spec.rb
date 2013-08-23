require 'spec_helper'

describe AppError::IapError do
  it "should create an exception with correct info." do
    error_codes = {
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
    error_codes.keys.each do |code|
      e = AppError::IapError.new(code)
      e.code.should == code
      e.status.should == error_codes[code][:status]
      e.msg.should == "#{error_codes[code][:msg]}(#{code})"
    end
  end

  it "should create an exception with the masked message." do
    code = 20001
    default_masked_msg = 'Error occurs.'
    e = AppError::IapError.new(code, :masked)
    e.msg.should == "#{default_masked_msg}(#{code})"
  end

  it "should create an exception with the given message." do
    msg = 'A given message.'
    code = 20001
    e = AppError::IapError.new(code, msg)
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
