require 'spec_helper'

describe AppError::Base do
  it "should raise an exception if the child class has no error_class method." do
    class TestError < AppError::Base; end
    code = 'unknown_code'
    expect{ TestError.new(code) }.to raise_error(StandardError)
  end

  it "should create an exception with the default message if no default_masked_msg method is given." do
    class TestError < AppError::Base
      def error_codes; {}; end
    end
    code = 'unknown_code'
    e = TestError.new(code, :masked)
    e.msg.should == 'Error occurs.(99999)'
  end
end
