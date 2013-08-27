require 'spec_helper'

describe AppError::IapError do
  it "should create an exception with correct info." do
    error_codes = {
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
      20100 => {
        :status => :duplicated,
        :msg => 'A duplicated IAP request is sent.'
      },
      20200 => {
        :status => :retry,
        :msg => 'Client should send the IAP request again.'
      }
    }
    error_codes.keys.each do |code|
      e = AppError::IapError.new(code, nil, { iap_info: {} })
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
    e = AppError::IapError.new(code)
    e.status.should == :internal_error
    e.code.should == AppError::INTERNAL_CODE
    e.msg.should == "#{AppError::INTERNAL_MSG}(#{AppError::INTERNAL_CODE})"
  end

  it "should create an exception with the given info." do
    info = { extra: 'A given info.'}
    code = 20001
    e = AppError::IapError.new(code, nil, info)
    e.info.should == info
  end

  it "should raise an exception if status is :success but no iap_info is given." do
    expect { AppError::IapError.new(:success) }.to raise_error(/provide iap_info/)
  end

  it "should raise an exception if status is :failed but no iap_info is given." do
    code = 20004
    expect { AppError::IapError.new(code) }.to raise_error(/provide iap_info/)
  end

  it "should raise an exception if the given iap_info is not a hash." do
    info = { iap_info: 'invalid_iap_info' }
    expect { AppError::IapError.new(:success, nil, info) }.to raise_error(/provide iap_info/)
  end

  it "should merge error_code into iap_info if iap_info is given." do
    code = 20001
    e = AppError::IapError.new(code, nil, { iap_info: {} })
    e.info[:iap_info][:error_code].should == code
  end
end
