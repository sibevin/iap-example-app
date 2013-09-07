module IapStore
  IAP_STORES = [AppStore.storecode, GooglePlay.storecode]

  class << self
    def check_tpv(storecode, sku, iap_info)
      store = create_store(storecode)
      store.check_tpv(sku, iap_info)
    end

    def show_raw_result(storecode, receipt)
      store = create_store(storecode)
      store.show_raw_result(receipt)
    end

    def support?(storecode)
      IAP_STORES.include?(storecode)
    end

    private

    def create_store(storecode)
      case storecode
      when AppStore.storecode
        AppStore.new
      when GooglePlay.storecode
        GooglePlay.new
      else
        raise AppError::IapError.new(20003, "Unknown store #{storecode}.")
      end
    end
  end
end
