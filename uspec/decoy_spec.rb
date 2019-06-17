# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/impasta/spies/decoy"

klass = Impasta

spec "tracks passed in messsages" do
  imp = klass.dummy "whatever"
  imp.foo "fooarg1"
  imp.bar(){ p 'bar' }

  imp.impasta.methods.map{|name,_,_| name} == [:foo,:bar] || imp.impasta.methods
end

spec "always returns itself" do
  imp = klass.dummy "whatever"
  imp.whatever == imp
end
