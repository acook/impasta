require_relative "spy"

module Impasta
  class Infiltrate < Spy
    def method_missing name, *args, &block
      super name, *(args << block) do
        self if impasta.object.respond_to? name
      end
    end
  end
end
