# frozen_string_literal: true

require_relative "spec_helper"

class ::FakeSpy < Impasta::Spy
  def __impasta_method name, args, block
    ::Array.nonexistant
  end
end

spec "raises method missing error if they don't refer to self" do
  begin
    spy = ::FakeSpy.new
    spy.should_hit_method_missing
  rescue NoMethodError => error
    error.message.include?("nonexistant") || error
  end
end
