require_relative 'spy'

module Impasta
  class Disguise < Spy
    def method_missing name, *args, &block
      ImpastaHelper.method_missing_helper self, [name, args, block] do
        self if impasta.klass.method_defined? name
      end
    end
  end
end
