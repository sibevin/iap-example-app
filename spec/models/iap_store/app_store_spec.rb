require 'spec_helper'

describe IapStore::AppStore do
  let(:sku) { create(:sku) }
  let(:storeskucode) { '525366573' }
  let(:storecode) { IapStore::AppStore.storecode }
  let(:transaction) { '349878819331301' }
  let(:purchase_date) { '2013-08-28 23:42:32 Etc/GMT' }
  let(:receipt) { 'test_receipt' }
  let(:succ_res) do
    {
      'receipt' => {
        'original_purchase_date_pst' => '2013-08-28 16:42:32 America/Los_Angeles',
        'unique_identifier' => 'a25775dbe876acc50cdf07e0e84396f7a73807fe',
        'original_transaction_id' => transaction,
        'bvrs' => '1.0.0.0',
        'app_item_id' => '178100801',
        'transaction_id' => transaction,
        'quantity' => '1',
        'unique_vendor_identifier' => '35392306-0F69-59E6-4D37-D4BDE5F16E6A',
        'product_id' => 'com.your.item.identifier',
        'item_id' => storeskucode,
        'version_external_identifier' => '66851710',
        'bid' => 'com.your.app.identity',
        'purchase_date_ms' => '1377733352209',
        'purchase_date' => purchase_date,
        'purchase_date_pst' => '2013-08-28 16:42:32 America/Los_Angeles',
        'original_purchase_date' => '2013-08-28 23:42:32 Etc/GMT',
        'original_purchase_date_ms' => '1377733352209'
      },
      'status' => 0
    }
  end
  let(:formal_url) { 'https://buy.itunes.apple.com/verifyReceipt' }
  let(:sandbox_url) { 'https://sandbox.itunes.apple.com/verifyReceipt' }

  before(:each) do
    @store_skucode = create(:store_skucode,
                             sku_id: sku.id,
                             storecode: storecode,
                             skucode: storeskucode)
    @user = create(:user)
    @iap_info = {
      user_id: @user.id,
      store: storecode,
      receipt: receipt,
      transaction_val: transaction,
      pinfo: 'test_purchase_info',
      dinfo: 'test_device_info',
      sku_id: sku.id
    }
    @sent_data = {
      'receipt-data' => receipt
    }.to_json
  end

  describe "#check_tpv" do
    it "should return the purchase info if success." do
      res = double(Object)
      res.stub(:parsed_response)
      HTTParty.should_receive(:post).with(formal_url, body: @sent_data).and_return(res)
      JSON.should_receive(:parse).and_return(succ_res)
      result = IapStore::AppStore.new.check_tpv(sku, @iap_info)
      result[:status].should == 0
      result[:purchased_at].should == Time.parse(purchase_date.gsub(/Etc\/GMT/, 'UTC'))
      result[:expires_at].should be_nil
    end

    it "should call sandbox server if the given receipt is a sandbox one." do
      sandbox_res = { 'status' => 21007 }
      res = double(Object)
      res.stub(:parsed_response)
      HTTParty.should_receive(:post).with(formal_url, body: @sent_data).and_return(res)
      JSON.should_receive(:parse).and_return(sandbox_res)
      HTTParty.should_receive(:post).with(sandbox_url, body: @sent_data).and_return(res)
      JSON.should_receive(:parse).and_return(succ_res)
      result = IapStore::AppStore.new.check_tpv(sku, @iap_info)
      result[:status].should == 21007
      result[:purchased_at].should == Time.parse(purchase_date.gsub(/Etc\/GMT/, 'UTC'))
      result[:expires_at].should be_nil
    end

    it "should raise a 20100 error if store server has no response." do
      HTTParty.should_receive(:post).with(formal_url, body: @sent_data).and_return(nil)
      expect { result = IapStore::AppStore.new.check_tpv(sku, @iap_info) }.to raise_error { |error|
        error.should be_a(AppError::IapError)
        error.einfo[:code].should == 20200
        error.einfo[:status].should == :retry
      }
    end

    it "should raise a 21991 error if the store server returns an unknown format." do
      res = double(Object)
      res.stub(:parsed_response).and_return('not_an_json_format')
      HTTParty.should_receive(:post).with(formal_url, body: @sent_data).and_return(res)
      expect { result = IapStore::AppStore.new.check_tpv(sku, @iap_info) }.to raise_error { |error|
        error.should be_a(AppError::IapAppStoreError)
        error.einfo[:code].should == 21991
        error.einfo[:status].should == :failed
      }
    end

    it "should raise a 21991 error if the store server returns an invalid result." do
      invalid_res_list = [
        {}, # no status
        { 'status' => 0 }, # status is 0, but no receipt
        { # empty receipt
          'status' => 0,
          'receipt' => {}
        },
        { # receipt has no transaction_id
          'status' => 0,
          'receipt' => {
            'item_id' => storeskucode,
            'purchase_date' => purchase_date
          }
        },
        { # receipt has no purchase_date
          'status' => 0,
          'receipt' => {
            'item_id' => storeskucode,
            'transaction_id' => transaction
          }
        }
      ]
      invalid_res_list.each do |invalid_res|
        res = double(Object)
        res.stub(:parsed_response)
        HTTParty.should_receive(:post).with(formal_url, body: @sent_data).and_return(res)
        JSON.should_receive(:parse).and_return(invalid_res)
        expect { result = IapStore::AppStore.new.check_tpv(sku, @iap_info) }.to raise_error { |error|
          error.should be_a(AppError::IapAppStoreError)
          error.einfo[:code].should == 21991
          error.einfo[:status].should == :failed
        }
      end
    end

    it "should raise a 20008 error if the given transaction is not matched." do
      iap_info = @iap_info.merge(transaction_val: 'invalid_transaction')
      res = double(Object)
      res.stub(:parsed_response)
      HTTParty.should_receive(:post).with(formal_url, body: @sent_data).and_return(res)
      JSON.should_receive(:parse).and_return(succ_res)
      expect { result = IapStore::AppStore.new.check_tpv(sku, iap_info) }.to raise_error { |error|
        error.should be_a(AppError::IapAppStoreError)
        error.einfo[:code].should == 20008
        error.einfo[:status].should == :failed
      }
    end

    it "should raise a 20009 error if the given storecode is not matched." do
      res = double(Object)
      res.stub(:parsed_response)
      HTTParty.should_receive(:post).with(formal_url, body: @sent_data).and_return(res)
      JSON.should_receive(:parse).and_return(succ_res)
      sku.should_receive(:'store_skucode_match?').with(storecode,storeskucode).and_return(false)
      expect { result = IapStore::AppStore.new.check_tpv(sku, @iap_info) }.to raise_error { |error|
        error.should be_a(AppError::IapAppStoreError)
        error.einfo[:code].should == 20009
        error.einfo[:status].should == :failed
      }
    end
  end
end
