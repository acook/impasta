require_relative "spy"

module Impasta
  class Wiretap < Spy
    def __impasta_method name, args, block
      impasta.object.public_send :name, *args, &block
    end
  end
end
