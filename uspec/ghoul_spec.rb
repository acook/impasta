# frozen_string_literal: true

require_relative "spec_helper"

ghoul = Impasta.ghoul object: []

spec "always returns nil for messages an object responds to" do
  ghoul.first == nil || ghoul.first
end

spec "raises errors for messages an object doesn't repond to" do
  begin
    ghoul.nonexistant
  rescue Impasta::MissingMethod => error
    error.message.include?("nonexistant") || error
  end
end
