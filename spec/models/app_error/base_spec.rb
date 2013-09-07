require 'spec_helper'

describe AppError::Base do
  it "should raise an exception if the child class has no error_class method." do
    class TestError1 < AppError::Base; end
    code = 'unknown_code'
    expect { TestError1.new(code) }.to raise_error(/error_codes method/)
  end

  it "should create an exception with the default message if no default_masked_msg method is given." do
    class TestError2 < AppError::Base
      def error_codes; {}; end
    end
    code = 'unknown_code'
    e = TestError2.new(code, :masked)
    e.msg.should == 'Error occurs.(99999)'
  end

  it "should raise an exception if a AppError::Base is built." do
    code = 'unknown_code'
    expect { AppError::Base.new(code) }.to raise_error(/implement/)
  end
end
