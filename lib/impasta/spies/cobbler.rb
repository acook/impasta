require_relative "spy"

module Impasta
  class Cobbler < Spy
    def __impasta_method name, args, block
      method = impasta.forged_methods[name]
      method.call if method
    end
  end
end
