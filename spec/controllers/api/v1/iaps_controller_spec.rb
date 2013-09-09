require 'spec_helper'

describe Api::V1::IapsController do
  let(:user) { create(:user) }
  let(:sku) { create(:sku) }
  before(:each) do
    basic_auth(user.email, user.password)
    @params = {
      'iap' => {
        'store' => 'appstore',
        'receipt' => 'receipt',
        'transaction' => 'transaction',
        'pinfo' => 'price=199,currency=USD,amount=1',
        'dinfo' => 'appver=1.0.0.0,platform=iPad,os=iOS,osver=6.1.1',
        'sku' => sku.skucode
      }
    }
  end
  describe "#create" do
    it "should return 200 if success." do
      succ_result = {
        status: :success,
        info: {
          iap_info: {
            user_id: user.id,
            store: @params['iap']['store'],
            receipt: @params['iap']['receipt'],
            transaction_val: @params['iap']['transaction'],
            pinfo: @params['iap']['pinfo'],
            dinfo: @params['iap']['dinfo'],
            sku_id: sku.id
          }
        }
      }
      IapHandler.should_receive(:check_request).with(@params['iap'], user).and_return(succ_result)
      InAppPurchase.should_receive(:create).with(succ_result[:info][:iap_info])
      post :create, @params
      response.code.should == '200'
      response.body.should == { status: 0 }.to_json
    end

    it "should return 422 if some params are missing." do
      invalid_params = {}
      post :create, invalid_params
      response.code.should == '422'
      @params['iap'].keys.each do |key|
        invalid_params = @params.merge(key => nil)
        post :create, invalid_params
        response.code.should == '422'
      end
    end

    it "should return 200 if status is :duplicated." do
      dup_result = {
        status: :duplicated
      }
      IapHandler.should_receive(:check_request).with(@params['iap'], user).and_return(dup_result)
      post :create, @params
      response.code.should == '200'
    end

    it "should return 422 if status is :invalid_request." do
      invalid_result = {
        status: :invalid_request
      }
      IapHandler.should_receive(:check_request).with(@params['iap'], user).and_return(invalid_result)
      post :create, @params
      response.code.should == '422'
    end

    it "should return 200 and store the failed purchase if status is :failed." do
      error_code = 'test_error_code'
      error_msg = 'test_error_msg'
      failed_result = {
        status: :failed,
        code: error_code,
        msg: error_msg,
        info: {
          iap_info: {
            user_id: user.id,
            store: @params['iap']['store'],
            receipt: @params['iap']['receipt'],
            transaction_val: @params['iap']['transaction'],
            pinfo: @params['iap']['pinfo'],
            dinfo: @params['iap']['dinfo'],
            sku_id: sku.id
          }
        }
      }
      IapHandler.should_receive(:check_request).with(@params['iap'], user).and_return(failed_result)
      FailedPurchase.should_receive(:create).with(failed_result[:info][:iap_info])
      post :create, @params
      response.code.should == '200'
      failed_json = {
        status: 1,
        code: error_code,
        msg: error_msg
      }.to_json
      response.body.should == failed_json
    end

    it "should return 200 if status is :retry." do
      retry_result = {
        status: :retry
      }
      IapHandler.should_receive(:check_request).with(@params['iap'], user).and_return(retry_result)
      post :create, @params
      response.code.should == '200'
    end
  end
end
