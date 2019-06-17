# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/impasta/spies/infiltrate"

klass = Impasta

spec "tracks passed in messsages" do
  imp = klass.infiltrate Array
  imp.first
  imp.each

  imp.impasta.methods.map{|name,_,_| name} == [:first, :each] || imp.impasta.methods
end

spec "provides useful info for #inspect" do
  imp = klass.infiltrate Array
  expected = "Infiltrate impersonating Array"
  actual = imp.impasta.inspect
  actual.include?(expected) || actual
end

spec "disallows methods unknown to the source object" do
  imp = klass.infiltrate Array
  begin
    imp.nonexistant_method
  rescue klass::MissingMethod
    true # correct error type returned
  end
end

spec "captures errors and stores the parent error" do
  imp = klass.infiltrate Array
  begin
    imp.nonexistant_method
  rescue klass::MissingMethod => error
    error.parent_exception.is_a? NameError || error # this is the original error, should you need it
  end
end

spec "captures errors and stores where the Impasta was instantiated" do
  imp = klass.infiltrate Array
  begin
    imp.nonexistant_method
  rescue klass::MissingMethod => error
    error.definition.include?("#{__FILE__}:#{__LINE__ - 4}") || error.definition # this is where you defined the Impasta object
  end
end

spec "captures errors and stores the list of methods (including args/block) accessed" do
  imp = klass.infiltrate Array

  # verbosely documenting the code rather than concise:
  expected_methods = [] # will be a list of arrays, each array representing a method call in order
  method_name = :nonexistant_method # the first element contains the method name as a symbol
  no_args_passed = [] # the second element contains the arguments passed, it will be an empty array if none
  no_block_given = nil # the third element indicates if a block was provided to the method
  expected_methods << [method_name, no_args_passed, no_block_given]

  begin
    imp.nonexistant_method
  rescue klass::MissingMethod => error
    error.accessed_methods == expected_methods || error.accessed_methods # this will be a list of any of the methods called on it
  end
end

spec "captures errors and stores the expected object instance" do
  imp = klass.infiltrate Array
  begin
    imp.nonexistant_method
  rescue klass::MissingMethod => error
    error.object == [] || error.object # this is what Impasta thinks the object should be
  end
end

spec "captures errors and stores the missing method name" do
  imp = klass.infiltrate Array
  begin
    imp.nonexistant_method
  rescue klass::MissingMethod => error
    error.method_name == :nonexistant_method || error.method_name # this is the method that wasn't found
  end
end
