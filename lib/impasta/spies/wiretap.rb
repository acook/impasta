require_relative "spy"

module Impasta
  class Wiretap < Spy
    def method_missing name, *args, &block
      ImpastaHelper.method_missing_helper self, [name, args, block] do
        impasta.object.public_send :name, *args, &block
      end
    end
  end
end
