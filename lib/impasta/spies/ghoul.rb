require_relative "spy"

module Impasta
  class Ghoul < Spy
    def __impasta_method name, args, block
      self if impasta.object.respond_to? name
    end

    def method_missing name, *args, &block
      super name, *args, &block
      nil
    end
  end
end
