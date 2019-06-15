module Impasta2
  extend self
  # will respond to anything with self
  def decoy aka = nil
    spy = Decoy.new
      secret = spy.impasta
      secret.trace = caller
      secret.aka = aka
      secret.codename = "#<#{Decoy}:#{secret.aka}>"
    spy
  end
  alias dummy decoy

  # responds to any message an instance of the given class would
  def infiltrate klass, aka = nil
    raise ArgumentError unless klass.is_a? Class
    spy = Infiltrate.new
      secret = spy.impasta
      secret.trace = caller
      secret.klass = klass
      secret.object = klass.new
      secret.aka = aka
      secret.codename = "#<#{Infiltrate}:#{secret.object}>"
    spy
  end
  alias double infiltrate

  # only responds to methods defined, not just any message it can respond to, works with modules too
  def disguise klass, aka = nil
    raise ArgumentError unless klass.is_a? Module
    spy = Disguise.new
      secret = spy.impasta
      secret.trace = caller
      secret.klass = klass
      secret.object = klass
      secret.aka = aka
      secret.codename = "#<#{Disguise}:(#{klass.class})#{klass}>"
      spy
  end
  alias mock disguise

  # pass method calls on to wrapped object
  def wiretap object, aka = nil
    spy = Wiretap.new
      secret = spy.impasta
      secret.trace = caller
      secret.klass = object.class
      secret.object = object
      secret.aka = aka
      secret.codename = "#<#{Wiretap}:(#{secret.klass})#{object}>"
      spy
  end
  alias proxy wiretap

  # like wiretap but blows up if it recieves a certain message
  #def informant object

  # contains only the specific messages defined in it, any thing else is an error
  #def plant
  #alias plant stub

  class Secret
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

  class Spy < BasicObject
    def impasta
      @__impasta_secrets ||= Secret.new
    end

    def to_s
      impasta.codename.to_s
    end

    def to_str
      "SPY #{impasta.codename}"
    end

    def inspect
      "#<#{self}:#{impasta.klass ? impasta.klass.name + " - " : ""}#{impasta.aka}>"
    end

    def method_missing name, *args, &block
      ::Kernel.p name if $DEBUG
      impasta.methods << [name, args, args.pop]
      yield || super
    rescue ::NameError => error
      ::Kernel.raise NoSuchMethod.new self, error
    end
  end

  class Decoy < Spy
    def method_missing name, *args, &block
      ImpastaHelper.method_missing_helper self, [name, args, block] do
        self
      end
    end
  end

  class Infiltrate < Spy
    def method_missing name, *args, &block
      super name, *(args << block) do
        self if impasta.object.respond_to? name
      end
    end
  end

  class Disguise < Spy
    def method_missing name, *args, &block
      ImpastaHelper.method_missing_helper self, [name, args, block] do
        self if impasta.klass.method_defined? name
      end
    end
  end

  class Wiretap < Spy
    def method_missing name, *args, &block
      ImpastaHelper.method_missing_helper self, [name, args, block] do
        impasta.object.public_send :name, *args, &block
      end
    end
  end

  module ImpastaHelper
    class << self
      def method_missing_helper obj, meth
        obj.impasta.methods << meth #[name, args, block]
        yield
      rescue ::NameError => error
        raise NoSuchMethod.new self, error
      end
    end
  end

  class NoSuchMethod < NameError
    def initialize impasta, parent_exception
      @impasta, @parent_exception = impasta, parent_exception
      @custom_message = "invalid message `#{method_info}' for #{object_info}"
    end
    attr :impasta, :parent_exception, :custom_message

    def custom_backtrace
      parent_exception.backtrace[1..-1]
    end

    alias_method :super_message, :message
    alias_method :message, :custom_message
    alias_method :super_backtrace, :backtrace
    alias_method :backtrace, :custom_backtrace

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
      dump(:methods) || Array.new
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
