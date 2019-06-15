require_relative "../secrets"
require_relative "../missing_method"

module Impasta
  class Spy < BasicObject
    def impasta
      @__impasta_secrets ||= Secrets.new
    end

    def to_s
      impasta.codename.to_s
    end

    def to_str
      "SPY #{impasta.codename}"
    end

    def inspect
      "#<#{self}:#{impasta.klass ? impasta.klass.name + " - " : ""}#{impasta.aka}>"
    end

    def method_missing name, *args, &block
      ::Kernel.p name if $DEBUG
      impasta.methods << [name, args, args.pop]
      yield || super
    rescue ::NameError => error
      ::Kernel.raise MissingMethod.new self, error
    end
  end
end
