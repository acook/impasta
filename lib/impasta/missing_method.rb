module Impasta
  class MissingMethod < ::NoMethodError
    def initialize spy, parent_exception
      @spy, @parent_exception = spy, parent_exception
      @secrets = spy.impasta
      @target = spy.impasta.target
    end
    attr :spy, :parent_exception, :secrets, :target

    def secrets
      spy.impasta
    end

    def target
      secrets.target
    end

    def ledger
      secrets.ledger
    end

    def origin
      secrets.origin
    end

    def backtrace
      parent_exception.backtrace[1..-1]
    end

    def message
      "invalid message #{method_info} for #{target_info}"
    end

    def target_info
      if Class == target then
        target.name
      elsif String == target
        "Imposter target `#{target}' defined at `#{secrets.origin}'"
      else
        "instance of `#{target.class} < #{target.class.superclass}'"
      end
    end

    def method_info
      if method_name then
        info =  "`#{method_name}'"
        info << " with args: #{args}" if args && !args.empty?
        if block then
          info << (args ? ' and' : ' with')
          info << " block: #{block.inspect}"
        end
        info
      else
        parent_exception.message.gsub /impasta/, target.class.to_s
      end
    end

    def method_name
      bad_message[0]
    end

    def args
      bad_message[1]
    end

    def block
      bad_message[2]
    end

    def bad_message
      ledger.last
    end
  end
end
