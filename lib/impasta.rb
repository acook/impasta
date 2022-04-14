require_relative "impasta/version"
require_relative "impasta/spies/spy"

module Impasta
  extend self

  # will respond to anything with self
  # a type of dummy object
  def decoy target: nil, aka: nil
    require_relative "impasta/spies/decoy"
    Decoy.new target: target, aka: aka
  end

  # responds to any message the given object does with self, raise for anything else
  # raise for everything if no object provided
  # a type of test double
  def infiltrate target: nil, aka: nil
    require_relative "impasta/spies/infiltrate"
    Infiltrate.new target: target, aka: aka
  end

  # pass method calls on to wrapped object
  # a proxy object
  def wiretap target: nil, aka: nil
    require_relative "impasta/spies/wiretap"
    Wiretap.new target: target, aka: aka
  end

  # return nil for any recognized message, raise for unrecognized
  # a type of null object
  def ghoul target: nil, aka: nil
    require_relative "impasta/spies/ghoul"
    Ghoul.new target: target, aka: aka
  end
end
