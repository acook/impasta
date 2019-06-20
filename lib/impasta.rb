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
    end
  end

  # responds to any message the given object does with self, raise for anything else
  # raise for everything if no object provided
  # a type of test double
  def infiltrate object: nil, aka: nil
    require_relative "impasta/spies/infiltrate"
    Infiltrate.new do |secret|
      secret.object = object
      secret.aka = aka
    end
  end

  # only responds to methods defined, not just any message it can respond to, works with modules too
  # a more constrained test double, avoids method_missing shenanigans
  def disguise klass, aka: nil
    raise ArgumentError unless klass.is_a? Module

    require_relative "impasta/spies/disguise"
    spy = Disguise.new do |secret|
      secret.klass = klass
      secret.object = klass
      secret.aka = aka
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
    end
  end

  # use cobbler.secrets.forge to specify methods to accept, anything else will error out
  # a type of stub or fake object
  def cobbler aka: nil, &block
    require_relative "impasta/spies/cobbler"
    spy = Cobbler.new do |secret|
      secret.aka = aka
      yield secret if block_given?
    end
  end


  # like wiretap but blows up if it recieves a certain message
  #def informant object

end
