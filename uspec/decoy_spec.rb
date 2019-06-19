# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/impasta/spies/decoy"

dummy = Impasta.dummy aka: "whatever"

spec "tracks passed in messsages" do
  dummy.foo "fooarg1"
  dummy.bar(){ p 'bar' }

  dummy.impasta.ledger.map{|name,_,_| name} == [:foo,:bar] || dummy.impasta.ledger
end

spec "always returns itself" do
  dummy.whatever == dummy
end
