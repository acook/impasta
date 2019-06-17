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
