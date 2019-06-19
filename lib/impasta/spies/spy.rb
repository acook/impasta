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

    def inspect
      "#<#{impasta.codename}>"
    end

    def method_missing name, *args, &block
      ::Kernel.p name if $DEBUG
      impasta.ledger << [name, args, block]
      __impasta_method(name, args, block) || super
    rescue ::NoMethodError => error
      ::Kernel.raise unless error.receiver == self
      ::Kernel.raise MissingMethod.new self, error
    end

    def __impasta_method name, args, block
      false
    end
  end
end
