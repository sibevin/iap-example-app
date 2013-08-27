require 'spec_helper'

describe IapHandler do
  before(:each) do
    @user = create(:user)
    @sku = create(:sku)
    @params = {
      :pinfo => 'price=199,currency=USD,amount=1',
      :dinfo => 'appver=1.0.0.0,platform=iPad,os=iOS,osver=6.1.1',
      :store => 'appstore',
      :transaction => 'transaction',
      :receipt => 'receipt',
      :sku => @sku.skucode
    }
  end

  describe ".check_request" do
    it "should return succ information if passed." do
      tpv_result = {
        :purchased_at => 1.hour.ago,
        :expires_at => 1.hour.since
      }
      InAppPurchase.stub_chain(:where, :first).and_return(nil)
      IapStore.should_receive(:support?).with(@params[:store]).and_return(true)
      IapStore.should_receive(:check_tpv).
        with(@params[:store], @params).
        and_return(tpv_result)
      result = IapHandler.check_request(@params, @user)
      result[:status].should == :success
      result[:code].should == AppError::SUCCESS_CODE
      iap_info = result[:info][:iap_info]
      iap_info[:user_id].should == @user.id
      iap_info[:sku_id].should == @sku.id
      iap_info[:receipt] == @params[:receipt]
      iap_info[:transaction_val] == @params[:transaction]
      iap_info[:pinfo].should == @params[:pinfo]
      iap_info[:dinfo].should == @params[:dinfo]
      iap_info[:error_code].should == AppError::SUCCESS_CODE
      iap_info[:purchased_at].should == tpv_result[:purchased_at]
      iap_info[:expires_at].should == tpv_result[:expires_at]
    end

    it "should raise a 20001 IAP error if the given pinfo format is incorrect." do
      params = @params.merge(:pinfo => 'invalid_pinfo')
      result = IapHandler.check_request(params, @user)
      result[:code].should == 20001
      result[:status].should == :invalid_request
    end

    it "should raise a 20002 IAP error if the given dinfo format is incorrect." do
      params = @params.merge(:dinfo => 'invalid_dinfo')
      result = IapHandler.check_request(params, @user)
      result[:code].should == 20002
      result[:status].should == :invalid_request
    end

    it "should raise a 20003 IAP error if the given store is invalid." do
      params = @params.merge(:store => 'invalid_store')
      result = IapHandler.check_request(params, @user)
      result[:code].should == 20003
      result[:status].should == :invalid_request
    end

    it "should raise a 20004 IAP error if the given transation is a JB one." do
      jb_transaction = 'com.urus.iap.30744321'
      params = @params.merge(:transaction => jb_transaction)
      IapStore.should_receive(:support?).with(params[:store]).and_return(true)
      result = IapHandler.check_request(params, @user)
      result[:code].should == 20004
      result[:status].should == :failed
      iap_info = result[:info][:iap_info]
      iap_info[:user_id].should == @user.id
      iap_info[:sku_id].should == nil
      iap_info[:receipt] == @params[:receipt]
      iap_info[:transaction_val] == jb_transaction
      iap_info[:pinfo].should == @params[:pinfo]
      iap_info[:dinfo].should == @params[:dinfo]
      iap_info[:error_code].should == 20004
    end

    it "should raise a 20005 IAP error if the given sku is invalid." do
      params = @params.merge(:sku => 'invalid_skucode')
      IapStore.should_receive(:support?).with(params[:store]).and_return(true)
      result = IapHandler.check_request(params, @user)
      result[:code].should == 20005
      result[:status].should == :invalid_request
    end

    it "should raise a 20006 IAP error if the transaction is duplicated but user is not the same." do
      user = create(:user)
      iap = create(:in_app_purchase,
                   :user_id => user.id,
                   :sku_id => @sku.id)
      IapStore.should_receive(:support?).with(@params[:store]).and_return(true)
      InAppPurchase.stub_chain(:where, :first).and_return(iap)
      result = IapHandler.check_request(@params, @user)
      result[:code].should == 20006
      result[:status].should == :failed
      iap_info = result[:info][:iap_info]
      iap_info[:user_id].should == @user.id
      iap_info[:sku_id].should == @sku.id
      iap_info[:receipt] == @params[:receipt]
      iap_info[:transaction_val] == @params[:transaction]
      iap_info[:pinfo].should == @params[:pinfo]
      iap_info[:dinfo].should == @params[:dinfo]
      iap_info[:error_code].should == 20006
    end

    it "should raise a 20007 IAP error if the transaction is duplicated but sku is not the same." do
      sku = create(:sku)
      iap = create(:in_app_purchase,
                   :user_id => @user.id,
                   :sku_id => sku.id)
      IapStore.should_receive(:support?).with(@params[:store]).and_return(true)
      InAppPurchase.stub_chain(:where, :first).and_return(iap)
      result = IapHandler.check_request(@params, @user)
      result[:code].should == 20007
      result[:status].should == :failed
      iap_info = result[:info][:iap_info]
      iap_info[:user_id].should == @user.id
      iap_info[:sku_id].should == @sku.id
      iap_info[:receipt] == @params[:receipt]
      iap_info[:transaction_val] == @params[:transaction]
      iap_info[:pinfo].should == @params[:pinfo]
      iap_info[:dinfo].should == @params[:dinfo]
      iap_info[:error_code].should == 20007
    end

    it "should raise a 20100 IAP error if the transaction is duplicated." do
      sku = create(:sku)
      iap = create(:in_app_purchase,
                   :user_id => @user.id,
                   :sku_id => @sku.id)
      IapStore.should_receive(:support?).with(@params[:store]).and_return(true)
      InAppPurchase.stub_chain(:where, :first).and_return(iap)
      result = IapHandler.check_request(@params, @user)
      result[:code].should == 20100
      result[:status].should == :duplicated
    end
  end
end
