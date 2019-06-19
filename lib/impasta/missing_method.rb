module Impasta
  class MissingMethod < ::NoMethodError
    def initialize impasta, parent_exception
      @impasta, @parent_exception = impasta, parent_exception
    end
    attr :impasta, :parent_exception

    def backtrace
      parent_exception.backtrace[1..-1]
    end

    def message
      "invalid message `#{method_info}' for #{object_info}"
    end

    def object_info
      if object.is_a?(Class) then
        object.name
      elsif object.is_a?(String)
        "Imposter object `#{object}' defined at `#{definition}'"
      else
        "instance of `#{object.class} < #{object.class.superclass}'"
      end
    end

    def method_info
      if method_name then
        info =  "`#{method_name}'"
        info << " with args: #{args}" if args
        if block then
          info << (args ? ' and' : ' with')
          info << " block: #{block.inspect}"
        end
        info
      else
        parent_exception.message.gsub /impasta/, dump(:class).to_s
      end
    end

    def method_name
      bad_message.first
    end

    def args
      bad_message[1]
    end

    def block_info
      block.inspect
    end

    def block
      bad_message.last
    end

    def bad_message
      accessed_methods.last
    end

    def definition
      dump(:trace).first
    end

    def accessed_methods
      dump(:ledger) || Array.new
    end

    def object
      dump(:object) || dump(:class) || dump(:nick) || dump(:name)
    end

    def dump key = nil
      @dump ||= impasta.impasta
      key ? @dump.send(key) : @dump
    end
  end
end
