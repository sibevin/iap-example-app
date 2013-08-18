module IapStore
  class AppStore < Base
    def self.storecode
      'aps'
    end

    def check_tpv(iap)
      # TODO
      p iap.inspect
    end
  end
end
