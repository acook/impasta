require "toisb"

module Impasta
  class Secrets
    def initialize spy, target: nil, aka: nil
      raise TypeError, "Spy not recognized, cannot hand Secrets to a #{spy.class}!" unless Spy === spy
      @spy = spy
      @handler = TOISB.wrap spy
      @trace = caller[4,caller.size]
      @forgeries = {}
      @ledger = []
      @target = target
      @aka = aka
    end
    attr_accessor :spy, :target, :codename, :aka, :trace, :handler, :forgeries, :ledger

    def within
      yield self if block_given?

      self
    end

    def forge method, returns: nil, &block_literal
      forgeries[method] = block_given? ?  block_literal : ->() { returns }
    end

    def inspect
      "#<#{self.class.name} for #{strategy}#{inspect_aka}>"
    end

    def can? method
      target.respond_to? method
    end

    def codename
      "#{strategy}#{inspect_aka}#{inspect_target}#{inspect_forgeries} from #{origin}"
    end

    def inspect_aka
      aka && " aka #{aka}" #|| ":0x#{handler.get_id}"
    end

    def inspect_target
      target && " impersonating #{target}"
    end

    def inspect_forgeries
      forgeries.empty? ? "" : " forging #{forgeries.keys.join(", ")}"
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
