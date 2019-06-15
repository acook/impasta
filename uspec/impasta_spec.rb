# frozen_string_literal: true

require_relative "spec_helper"

spec "tracks passed in messsages" do
  imp = Impasta.new "whatever"
  imp.foo
  imp.bar

  imp.impasta_dump[:methods].map{|name,_,_| name} == [:foo,:bar]
end

spec "dissallows methods unknown to the source object" do
  imp = Impasta.new Array
  begin
    imp.nonexistant_method
  rescue Impasta::ImpastaNoMethodError
    true
  end
end

spec "captures errors and stores the parent error" do
  imp = Impasta.new Array
  begin
    imp.nonexistant_method
  rescue Impasta::ImpastaNoMethodError => error
    error.parent_exception.is_a? NameError || error # this is the original error, should you need it
  end
end

spec "captures errors and stores where the Impasta was instantiated" do
  imp = Impasta.new Array
  begin
    imp.nonexistant_method
  rescue Impasta::ImpastaNoMethodError => error
    error.definition.include? "#{__FILE__}:#{__LINE__ - 4}" || error.definition # this is where you defined the Impasta object
  end
end

spec "captures errors and stores the list of methods accessed" do
  imp = Impasta.new Array
  begin
    imp.nonexistant_method
  rescue Impasta::ImpastaNoMethodError => error
    error.accessed_methods == [:nonexistant_method, [], nil] || error.accessed_methods # this will be a list of any of the methods called on it
  end
end

spec "captures errors and stores the expected object instance" do
  imp = Impasta.new Array
  begin
    imp.nonexistant_method
  rescue Impasta::ImpastaNoMethodError => error
    error.object == [] || error.object # this is what Impasta thinks the object should be
  end
end

spec "captures errors and stores the missing method name" do
  imp = Impasta.new Array
  begin
    imp.nonexistant_method
  rescue Impasta::ImpastaNoMethodError => error
    error.method_name == :nonexistant_method || error.method_name # this is the method that wasn't found
  end
end
