# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/impasta/spies/wiretap"

klass = Impasta
wire = klass.wiretap target: Array.new

spec "tracks passed in messsages" do
  local_wire = klass.wiretap target: Array.new
  local_wire.first
  local_wire.each

  local_wire.impasta.ledger.map{|name,_,_| name} == [:first, :each] || local_wire.impasta.ledger
end

spec "returns the correct value from a method call" do
  expected = :foobar
  wire << expected
  actual = wire.first
  actual == expected || actual
end
