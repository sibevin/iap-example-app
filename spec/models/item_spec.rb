require 'spec_helper'

describe Item do
  before(:each) do
    @item = create(:item)
    @sku = create(:sku, item_id: @item.id, onshelf: true)
    @sku2 = create(:sku, item_id: @item.id, onshelf: false)
  end

  describe "#set_onshelf!" do
    it "should set all skus which belong to this item on the shelf." do
      @item.set_onshelf!
      @item.skus.each do |sku|
        sku.should be_onshelf
      end
    end

    it "should set all skus which belong to this item off the shelf." do
      @item.set_onshelf!(false)
      @item.skus.each do |sku|
        sku.should_not be_onshelf
      end
    end
  end
end
