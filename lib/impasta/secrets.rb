require "toisb"

module Impasta
  class Secrets
    def initialize spy
      raise TypeError, "Spy not recognized, cannot hand Secrets to a #{spy.class}!" unless Spy === spy
      @spy = spy
      @handler = TOISB.wrap spy
    end
    attr_accessor :spy, :klass, :object, :codename, :aka, :trace, :handler

    def within
      yield self if block_given?

      self.trace = self.trace[4,self.trace.size] if trace && trace.size > 4

      self
    end

    def methods
      @methods ||= []
    end

    def aka
      @aka || codename
    end

    def inspect
      "<#{strategy}#{target ? " impersonating #{target}" : ""}#{aka ? " aka #{aka}" : ""} from #{trace.first}>"
    end

    def target
      klass || object
    end

    def can? method
      target.respond_to? method
    end

    def strategy
      handler.klass.name.split("::").last
    end
  end
end
