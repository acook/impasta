require_relative "spy"

module Impasta
  class Wiretap < Spy
    def __impasta_method name, args, block
      @__impasta_deaddrop = impasta.target.public_send name, *args, &block
      self
    end

    def method_missing name, *args, &block
      super name, *args, &block
      value, @__impasta_deaddrop = @__impasta_deaddrop, nil
      value
    end
  end
end
