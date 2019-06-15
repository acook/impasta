require_relative "spy"
require_relative "../helper"

module Impasta
  class Decoy < Spy
    def method_missing name, *args, &block
      ImpastaHelper.method_missing_helper self, [name, args, block] do
        self
      end
    end
  end
end
