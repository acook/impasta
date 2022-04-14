# frozen_string_literal: true

require_relative "spec_helper"

spec 'existance' do
  !!defined? Impasta
end
