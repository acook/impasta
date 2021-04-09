# frozen_string_literal: true

require_relative "spec_helper"

ghoul = Impasta.ghoul target: []

spec "always returns nil for messages a target responds to" do
  ghoul.first == nil || ghoul.first
end

spec "raises errors for messages a target doesn't repond to" do
  begin
    ghoul.nonexistant
  rescue Impasta::MissingMethod => error
    error.message.include?("nonexistant") || error
  end
end

spec "always returns nil when target is nil" do
  nil_ghoul = Impasta.ghoul
  nil_ghoul.whatever == nil || ghoul.first
end
