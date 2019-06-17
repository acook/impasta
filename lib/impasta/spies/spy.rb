require_relative "../secrets"
require_relative "../missing_method"

module Impasta
  class Spy < BasicObject
    def initialize **args, &block
      secret = @__impasta_secrets = Secrets.new self
      secret.within &block
    end

    def impasta
      @__impasta_secrets
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
      impasta.methods << [name, args, block]
      __impasta_method(name, args, block) || super
    rescue ::NoMethodError => error
      ::Kernel.raise MissingMethod.new self, error
    end

    def __impasta_method name, args, block
      false
    end
  end
end
