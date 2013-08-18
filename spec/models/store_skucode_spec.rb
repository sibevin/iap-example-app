require 'spec_helper'

describe StoreSkucode do
  before(:each) do
    @skucode = 'skucode1'
    @store_skucode = create(:store_skucode,
                            skucode: "#{@skucode},skucode2,skucode3")
  end
  describe "validations" do
    it "should have the unique storecode per sku." do
      expect { create(:store_skucode) }.to raise_error
    end
  end
  describe "#match_code?" do
    it "should return true if skucode is matched." do
      result = @store_skucode.match_code?(@skucode)
      result.should be_true
    end

    it "should return false if skucode is not matched." do
      skucode = 'not_matched_skucode'
      result = @store_skucode.match_code?(skucode)
      result.should be_false
    end
  end
end
