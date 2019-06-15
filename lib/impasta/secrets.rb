module Impasta
  class Secrets
    attr_accessor :klass, :object, :codename, :aka, :trace

    def methods
      @methods ||= []
    end

    def aka
      @aka || trace.first
    end

    def inspect
      impasta_dump.map do |var|
        text << "#{var}: #{instance_variable_get(var)}\n" if var.to_s =~ /impasta/
        text
      end
    end
  end
end
