# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/impasta/spies/infiltrate"

klass = Impasta
inf = klass.infiltrate target: Array.new

spec "tracks passed in messsages" do
  inf.first
  inf.each

  inf.impasta.ledger.map{|name,_,_| name} == [:first, :each] || imp.impasta.ledger
end

spec "provides useful info for #inspect" do
  expected = "#<Infiltrate impersonating "
  actual = inf.inspect
  actual.index(expected) == 0 || actual
end

spec "disallows methods unknown to the source object" do
  begin
    inf.nonexistant_method
  rescue klass::MissingMethod
    true # correct error type returned
  end
end

spec "captures errors and stores the parent error" do
  begin
    inf.nonexistant_method
  rescue klass::MissingMethod => error
    error.parent_exception.is_a? NameError || error # this is the original error, should you need it
  end
end

spec "captures errors and stores where the Impasta was instantiated" do
  expected = "#{File.basename __FILE__} line ##{__LINE__ + 1}"
  local_inf = klass.infiltrate target: Array.new

  begin
    local_inf.nonexistant_method
  rescue klass::MissingMethod => error
    actual = error.origin
    actual.include?(expected) || actual # this is where you defined the Impasta object
  end
end

spec "captures errors and stores the list of methods (including args/block) accessed" do
  # verbosely documenting the code rather than concise:
  expected_methods = [] # will be a list of arrays, each array representing a method call in order
  method_name = :nonexistant_method # the first element contains the method name as a symbol
  no_args_passed = [] # the second element contains the arguments passed, it will be an empty array if none
  no_block_given = nil # the third element indicates if a block was provided to the method
  expected_methods << [method_name, no_args_passed, no_block_given]
  local_inf = klass.infiltrate target: Array.new

  begin
    local_inf.nonexistant_method
  rescue klass::MissingMethod => error
    error.ledger == expected_methods || error.ledger # this will be a list of any of the methods called on it
  end
end

spec "captures errors and stores the expected object" do
  begin
    inf.nonexistant_method
  rescue klass::MissingMethod => error
    error.target == [] || error.target # this is what Impasta thinks the object should be
  end
end

spec "captures errors and stores the missing method name" do
  begin
    inf.nonexistant_method
  rescue klass::MissingMethod => error
    error.method_name == :nonexistant_method || error.method_name # this is the method that wasn't found
  end
end
