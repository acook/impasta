# frozen_string_literal: true

require_relative "spec_helper"

spec "returns whatever specified for forged methods, using lambda as block" do
  cobbler = Impasta.cobbler aka: "for testing" do |secrets|
    secrets.forge :passport, &->() { :valid_passport }
  end

  cobbler.passport == :valid_passport || cobbler.passport
end

spec "returns whatever specified for forged methods, using plain value" do
  cobbler = Impasta.cobbler aka: "for testing" do |secrets|
    secrets.forge :currency, returns: :valid_currency
  end

  cobbler.currency == :valid_currency || cobbler.currency
end

spec "raises errors for messages not forged" do
  cobbler = Impasta.cobbler aka: "for testing"
  begin
    cobbler.nonexistant
  rescue Impasta::MissingMethod => error
    error.message.include?("nonexistant") || error
  end
end
