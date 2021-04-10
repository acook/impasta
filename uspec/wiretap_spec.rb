# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/impasta/spies/wiretap"

klass = Impasta
wire = klass.wiretap target: Array.new

spec "returns the correct value from a method call" do
  expected = :foobar
  wire << expected
  actual = wire.first
  actual == expected || actual
end
