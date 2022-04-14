# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/impasta/spies/decoy"

decoy = Impasta.decoy aka: "whatever"

spec "tracks passed in messsages" do
  decoy.foo "fooarg1"
  decoy.bar(){ p 'bar' }

  decoy.impasta.ledger.map{|name,_,_| name} == [:foo,:bar] || decoy.impasta.ledger
end

spec "always returns itself" do
  decoy.whatever == decoy
end
