require "toisb"

module Impasta
  class Secrets
    def initialize spy
      raise TypeError, "Spy not recognized, cannot hand Secrets to a #{spy.class}!" unless Spy === spy
      @spy = spy
      @handler = TOISB.wrap spy
      @trace = caller[4,caller.size]
      @forged_methods = {}
      @ledger = []
    end
    attr_accessor :spy, :target, :codename, :aka, :trace, :handler, :forged_methods, :ledger

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

    def inspect
      "#<#{self.class.name} for #{strategy}#{inspect_aka}>"
    end

    def can? method
      target.respond_to_missing? method
    end

    def codename
      "#{strategy}#{inspect_aka}#{inspect_target}#{inspect_forged} from #{origin}"
    end

    def inspect_aka
      aka && " aka #{aka}" #|| ":0x#{handler.get_id}"
    end

    def inspect_target
      target && " impersonating #{target}"
    end

    def inspect_forged
      forged_methods.empty? ? "" : " forging #{forged_methods.keys.join(", ")}"
    end

    def origin
      file, line, _ = trace.first.split(":")
      "#{File.basename file} line ##{line}"
    end

    def strategy
      handler.klass.name.split("::").last
    end
  end
end
