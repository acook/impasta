# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/impasta/secrets"
require_relative "../lib/impasta/spies/infiltrate"

target = Array
spy = Impasta.infiltrate target
secrets = spy.impasta

spec "retains information about the spy" do
  secrets.target == target || secrets.target
end

spec "codename provides info" do
  expected = "Infiltrate impersonating Array from secrets_spec.rb line"
  actual = secrets.codename
  actual.include?(expected) || actual
end
