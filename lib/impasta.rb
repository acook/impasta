require_relative "impasta/version"
require_relative "impasta/spies/spy"

module Impasta
  extend self

  # will respond to anything with self
  def decoy aka: nil
    require_relative "impasta/spies/decoy"
    Decoy.new do |secret|
      secret.aka = aka
      secret.codename = "#<#{Decoy}:#{secret.aka}>"
    end
  end
  alias dummy decoy

  # responds to any message an instance of the given class would
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
  alias double infiltrate

  # only responds to methods defined, not just any message it can respond to, works with modules too
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
  alias mock disguise

  # pass method calls on to wrapped object
  def wiretap object, aka: nil
    require_relative "impasta/spies/wiretap"
    spy = Wiretap.new do |secret|
      secret.klass = object.class
      secret.object = object
      secret.aka = aka
      secret.codename = "#<#{Wiretap}:(#{secret.klass})#{object}>"
    end
  end
  alias proxy wiretap

  # like wiretap but blows up if it recieves a certain message
  #def informant object

  # contains only the specific messages defined in it, any thing else is an error
  #def plant
  #alias plant stub
end
