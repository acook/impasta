require "toisb"

module Impasta
  class Secrets
    def initialize spy
      raise TypeError, "Spy not recognized, cannot hand Secrets to a #{spy.class}!" unless Spy === spy
      @spy = spy
      @handler = TOISB.wrap spy
      @trace = caller[4,caller.size]
      @forged_methods = {}
    end
    attr_accessor :spy, :klass, :object, :codename, :aka, :trace, :handler, :forged_methods

    def within
      yield self if block_given?

      self
    end

    def forge method, returns: nil, &block_literal
      block = block_literal if block_given?
      block = ->() { returns } unless block
      block = ->() {} unless block
      forged_methods[method] = block
    end

    def ledger
      @ledger ||= []
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
