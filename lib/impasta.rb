require 'impasta/version'

module Impasta
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
end
