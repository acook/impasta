require_relative "spy"

module Impasta
  class Infiltrate < Spy
    def __impasta_method name, args, block
      self if impasta.object.respond_to? name
    end
  end
end