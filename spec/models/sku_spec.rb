require 'spec_helper'

describe Sku do
  before(:each) do
    @sku = create(:sku)
    @storecode = 'storecode'
    @skucode = 'skucode1'
    @store_skucode = create(:store_skucode,
                            sku_id: @sku.id,
                            storecode: @storecode,
                            skucode: "#{@skucode},skucode2,skucode3")
  end

  describe "#store_skucode_match?" do
    it "should return true if skucode is matched." do
      result = @sku.store_skucode_match?(@storecode, @skucode)
      result.should be_true
    end

    it "should return false if skucode is not matched." do
      skucode = 'not_matched_skucode'
      result = @sku.store_skucode_match?(@storecode, skucode)
      result.should be_false
    end

    it "should raise an exception if no store_skucode is found." do
      storecode = 'unknown_storecode'
      expect { @sku.store_skucode_match?(storecode, @skucode) }.to raise_error
    end
  end
end
