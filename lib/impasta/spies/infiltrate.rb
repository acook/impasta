require_relative "spy"

module Impasta
  class Infiltrate < Spy
    def __impasta_method name, args, block
      self if impasta.can?(name)
    end
  end
end
