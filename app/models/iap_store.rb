module IapStore
  IAP_STORES = [AppStore.storecode, GooglePlay.storecode]

  class << self
    def check_tpv(iap)
      store = create_store(iap.storecode)
      store.check_tpv(iap)
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
        raise "Unknown store #{storecode}."
      end
    end
  end
end
