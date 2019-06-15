require_relative "spy"

module Impasta
  class Decoy < Spy
    def __impasta_method name, args, block
      self
    end
  end
end
