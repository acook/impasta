module Impasta2
  extend self
  # will respond to anything with self
  def decoy aka = nil
    Decoy.new.tap do |spy|
      secret = spy.impasta
      secret.trace = caller
      secret.aka = aka
      secret.codename = "#<#{spy.class}:#{secret.aka}>"
    end
  end
  alias dummy decoy

  # responds to any message an instance of the given class would
  def infiltrate klass, aka = nil
    raise ArgumentError unless klass.is_a? Class
    Infiltrate.new.tap do |spy|
      secret = spy.impasta
      secret.trace = caller
      secret.klass = klass
      secret.object = klass.new
      secret.aka = aka
      secret.codename = "#<#{spy.class}:#{secret.object}>"
    end
  end
  alias double infiltrate

  # only responds to methods defined, not just any message it can respond to, works with modules too
  def disguise klass, aka = nil
    raise ArgumentError unless klass.is_a? Module
    Disguise.new.tap do |spy|
      secret = spy.impasta
      secret.trace = caller
      secret.klass = klass
      secret.object = klass
      secret.aka = aka
      secret.codename = "#<#{spy.class}:(#{klass.class})#{klass}>"
    end
  end
  alias mock disguise

  # pass method calls on to wrapped object
  def wiretap object, aka = nil
    Wiretap.new.tap do |spy|
      secret = spy.impasta
      secret.trace = caller
      secret.klass = object.class
      secret.object = object
      secret.aka = aka
      secret.codename = "#<#{spy.class}:(#{secret.klass})#{object}>"
    end
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

    def inspect
      "#<#{self.class}:#{impasta.klass ? impasta.klass.name + " - " : ""}#{impasta.aka}>"
    end

    def method_missing name, *args, &block
      impasta.methods << [name, args, block]
      yield || super
    rescue NoMethodError => error
      raise ::Impasta::ImpastaNoMethodError.new self, error
    end
  end

  class Decoy < Spy
    def method_missing name, *args, &block
      super do
        self
      end
    end
  end

  class Infiltrate < Spy
    def method_missing name, *args, &block
      super do
        self if impasta.object.respond_to? name
      end
    end
  end

  class Disguise < Spy
    def method_missing name, *args, &block
      super do
        self if impasta.klass.method_defined? name
      end
    end
  end

  class Wiretap < Spy
    def method_missing name, *args, &block
      super do
        impasta.object.public_send :name, *args, &block
      end
    end
  end

  module ImpastaHelper

  end
end
