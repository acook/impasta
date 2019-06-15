module Impasta
  module ImpastaHelper
    class << self
      def method_missing_helper obj, meth
        obj.impasta.methods << meth #[name, args, block]
        yield
      rescue ::NoMethodError => error
        raise MissingMethod.new self, error
      end
    end
  end
end
