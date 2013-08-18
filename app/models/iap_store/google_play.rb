module IapStore
  class GooglePlay < Base
    def self.storecode
      'gop'
    end

    def check_tpv(iap)
      # TODO
      p iap.inspect
    end
  end
end
