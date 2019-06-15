require_relative "spy"

module Impasta
  class Disguise < Spy
    def __impasta_method name, args, block
      self if impasta.klass.method_defined? name
    end
  end
end
