require 'spec_helper'

describe IapStore::Base do
  describe "#check_tpv" do
    it "should raise an exception if the child class has no check_tpv method." do
      class TestIapStore < IapStore::Base; end
      sku = 'test_sku'
      iap_info = 'test_info'
      expect{ TestIapStore.new.check_tpv(sku, iap_info) }.to raise_error(/check_tpv method/)
    end
  end

  describe "#show_raw_result" do
    it "should raise an exception if the child class has no show_raw_result method." do
      class TestIapStore < IapStore::Base; end
      receipt = 'test_receipt'
      expect{ TestIapStore.new.show_raw_result(receipt) }.to raise_error(/show_raw_result method/)
    end
  end
end
