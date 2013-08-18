module ActiveRecordInitExtension
  extend ActiveSupport::Concern
  module ClassMethods
    def create_init_seeds
      self::DEFAULT_SEEDS.each do |key, value|
        unless find_by_id(key)
          create!(self::DEFAULT_SEEDS[key].merge(id: key))
        end
      end
    end
  end
end
