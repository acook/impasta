require_relative "impasta/version"
require_relative "impasta/spies/spy"

module Impasta
  extend self

  # will respond to anything with self
  # a type of dummy object
  def decoy aka: nil
    require_relative "impasta/spies/decoy"
    Decoy.new do |secret|
      secret.aka = aka
      secret.codename = "#<#{Decoy}:#{secret.aka}>"
    end
  end

  # responds to any message an instance of the given class would
  # a type of test double
  def infiltrate klass, aka: nil
    raise ArgumentError unless klass.is_a? Class

    require_relative "impasta/spies/infiltrate"
    Infiltrate.new do |secret|
      secret.klass = klass
      secret.object = klass.new
      secret.aka = aka
      secret.codename = "#<#{Infiltrate}:#{secret.object}>"
    end
  end

  # only responds to methods defined, not just any message it can respond to, works with modules too
  # a more constrained test double
  def disguise klass, aka: nil
    raise ArgumentError unless klass.is_a? Module

    require_relative "impasta/spies/disguise"
    spy = Disguise.new do |secret|
      secret.klass = klass
      secret.object = klass
      secret.aka = aka
      secret.codename = "#<#{Disguise}:(#{klass.class})#{klass}>"
    end
  end

  # pass method calls on to wrapped object
  # a proxy object
  def wiretap object, aka: nil
    require_relative "impasta/spies/wiretap"
    spy = Wiretap.new do |secret|
      secret.klass = object.class
      secret.object = object
      secret.aka = aka
      secret.codename = "#<#{Wiretap}:(#{secret.klass})#{object}>"
    end
  end

  # return nil for any recognized message, raise for unrecognized
  # a type of null object
  def ghoul object: nil, aka: nil
    require_relative "impasta/spies/ghoul"
    spy = Ghoul.new do |secret|
      secret.klass = object.class if object
      secret.object = object
      secret.aka = aka
      secret.codename = "#<#{Ghoul}:(#{secret.klass})#{object}>"
    end
  end

  # like wiretap but blows up if it recieves a certain message
  #def informant object

  # contains only the specific messages defined in it, any thing else is an error
  #def plant
end
