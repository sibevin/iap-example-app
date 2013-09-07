require 'spec_helper'

describe IapStore do
  before(:all) do
    @sku = create(:sku)
    @iap_info = 'test_iap_info'
    @receipt = 'test_receipt'
    @stores = [IapStore::AppStore, IapStore::GooglePlay]
  end

  describe ".check_tpv" do
    it "should call check_tpv in a IapStore-based class according to the given storecode." do
      @stores.each do |store|
        store_handler = double(store)
        store.stub(:new).and_return(store_handler)
        store_handler.should_receive(:check_tpv).with(@sku, @iap_info).exactly(1).times
        IapStore.check_tpv(store.storecode, @sku, @iap_info)
      end
    end

    it "should raise a 20003 IAP error if the given store is invalid." do
      storecode = 'invalid_store'
      expect { IapStore.check_tpv(storecode, @sku, @iap_info) }.to raise_error { |error|
        error.should be_a(AppError::IapError)
        error.einfo[:code].should == 20003
        error.einfo[:status].should == :invalid_request
      }
    end
  end

  describe ".show_raw_result" do
    it "should call show_raw_result in a IapStore-based class according to the given storecode." do
      @stores.each do |store|
        store_handler = double(store)
        store.stub(:new).and_return(store_handler)
        store_handler.should_receive(:show_raw_result).with(@receipt).exactly(1).times
        IapStore.show_raw_result(store.storecode, @receipt)
      end
    end

    it "should raise a 20003 IAP error if the given store is invalid." do
      storecode = 'invalid_store'
      expect { IapStore.show_raw_result(storecode, @receipt) }.to raise_error { |error|
        error.should be_a(AppError::IapError)
        error.einfo[:code].should == 20003
        error.einfo[:status].should == :invalid_request
      }
    end
  end

  describe ".support?" do
    it "should return true if the given store is supported" do
      IapStore::IAP_STORES.each do |store|
        IapStore.support?(store).should be_true
      end
    end

    it "should return false if the given store is invalid." do
      store = 'invalid_store'
      IapStore.support?(store).should be_false
    end
  end
end
